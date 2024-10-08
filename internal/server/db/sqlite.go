package db

import (
	"database/sql"
	"database/sql/driver"
	"fmt"
	"log/slog"

	esql "entgo.io/ent/dialect/sql"
	"github.com/holos-run/holos/internal/ent"
	"github.com/holos-run/holos/internal/errors"
	"github.com/holos-run/holos/internal/holos"
	"modernc.org/sqlite"
)

// NewMemoryClientFactory returns a MemoryClientFactory implementation of ClientFactory
func NewMemoryClientFactory(cfg *holos.Config) *MemoryClientFactory {
	return &MemoryClientFactory{cfg: cfg}
}

// MemoryClientFactory produces simple in-memory sqlite database clients for development and testing.
type MemoryClientFactory struct {
	cfg *holos.Config
}

func (mc *MemoryClientFactory) New() (Conn, error) {
	log := mc.cfg.Logger()
	db, err := sql.Open("sqlite3", "file:db.sqlite3?mode=memory&cache=shared")
	if err != nil {
		log.Debug("could not open sql connection", "err", err)
		return Conn{}, errors.Wrap(err)
	}
	// Fix database is locked errors when testing with sqlite3 in-memory and parallel test cases.
	db.SetMaxOpenConns(1)
	drv := esql.OpenDB("sqlite3", db)
	client := withHooks(ent.NewClient(ent.Driver(drv)))
	return Conn{client, db, drv}, nil
}

// sqliteDriver sets PRAGMA foreign_keys = on for each new connection with modernc.org/sqlite
// See: https://github.com/ent/ent/discussions/1667#discussioncomment-1132296
type sqliteDriver struct {
	*sqlite.Driver
}

func (d sqliteDriver) Open(name string) (driver.Conn, error) {
	conn, err := d.Driver.Open(name)
	if err != nil {
		return conn, err
	}
	c := conn.(interface {
		Exec(stmt string, args []driver.Value) (driver.Result, error)
	})
	if _, err := c.Exec("PRAGMA foreign_keys = on;", nil); err != nil {
		if errClose := conn.Close(); errClose != nil {
			slog.Error("could not close", "err", errClose)
		}
		return nil, fmt.Errorf("could not enable foreign keys: %w", err)
	}
	return conn, nil
}

func init() {
	sql.Register("sqlite3", sqliteDriver{Driver: &sqlite.Driver{}})
}
