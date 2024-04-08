// Code generated by ent, DO NOT EDIT.

package ent

import (
	"fmt"
	"strings"
	"time"

	"entgo.io/ent"
	"entgo.io/ent/dialect/sql"
	"github.com/gofrs/uuid"
	"github.com/holos-run/holos/internal/server/ent/user"
	"github.com/holos-run/holos/internal/server/ent/useridentity"
)

// UserIdentity is the model entity for the UserIdentity schema.
type UserIdentity struct {
	config `json:"-"`
	// ID of the ent.
	ID uuid.UUID `json:"id,omitempty"`
	// CreatedAt holds the value of the "created_at" field.
	CreatedAt time.Time `json:"created_at,omitempty"`
	// UpdatedAt holds the value of the "updated_at" field.
	UpdatedAt time.Time `json:"updated_at,omitempty"`
	// Iss holds the value of the "iss" field.
	Iss string `json:"iss,omitempty"`
	// Sub holds the value of the "sub" field.
	Sub string `json:"sub,omitempty"`
	// Email holds the value of the "email" field.
	Email string `json:"email,omitempty"`
	// EmailVerified holds the value of the "email_verified" field.
	EmailVerified bool `json:"email_verified,omitempty"`
	// Name holds the value of the "name" field.
	Name *string `json:"name,omitempty"`
	// Edges holds the relations/edges for other nodes in the graph.
	// The values are being populated by the UserIdentityQuery when eager-loading is set.
	Edges        UserIdentityEdges `json:"edges"`
	user_id      *uuid.UUID
	selectValues sql.SelectValues
}

// UserIdentityEdges holds the relations/edges for other nodes in the graph.
type UserIdentityEdges struct {
	// User holds the value of the user edge.
	User *User `json:"user,omitempty"`
	// loadedTypes holds the information for reporting if a
	// type was loaded (or requested) in eager-loading or not.
	loadedTypes [1]bool
}

// UserOrErr returns the User value or an error if the edge
// was not loaded in eager-loading, or loaded but was not found.
func (e UserIdentityEdges) UserOrErr() (*User, error) {
	if e.User != nil {
		return e.User, nil
	} else if e.loadedTypes[0] {
		return nil, &NotFoundError{label: user.Label}
	}
	return nil, &NotLoadedError{edge: "user"}
}

// scanValues returns the types for scanning values from sql.Rows.
func (*UserIdentity) scanValues(columns []string) ([]any, error) {
	values := make([]any, len(columns))
	for i := range columns {
		switch columns[i] {
		case useridentity.FieldEmailVerified:
			values[i] = new(sql.NullBool)
		case useridentity.FieldIss, useridentity.FieldSub, useridentity.FieldEmail, useridentity.FieldName:
			values[i] = new(sql.NullString)
		case useridentity.FieldCreatedAt, useridentity.FieldUpdatedAt:
			values[i] = new(sql.NullTime)
		case useridentity.FieldID:
			values[i] = new(uuid.UUID)
		case useridentity.ForeignKeys[0]: // user_id
			values[i] = &sql.NullScanner{S: new(uuid.UUID)}
		default:
			values[i] = new(sql.UnknownType)
		}
	}
	return values, nil
}

// assignValues assigns the values that were returned from sql.Rows (after scanning)
// to the UserIdentity fields.
func (ui *UserIdentity) assignValues(columns []string, values []any) error {
	if m, n := len(values), len(columns); m < n {
		return fmt.Errorf("mismatch number of scan values: %d != %d", m, n)
	}
	for i := range columns {
		switch columns[i] {
		case useridentity.FieldID:
			if value, ok := values[i].(*uuid.UUID); !ok {
				return fmt.Errorf("unexpected type %T for field id", values[i])
			} else if value != nil {
				ui.ID = *value
			}
		case useridentity.FieldCreatedAt:
			if value, ok := values[i].(*sql.NullTime); !ok {
				return fmt.Errorf("unexpected type %T for field created_at", values[i])
			} else if value.Valid {
				ui.CreatedAt = value.Time
			}
		case useridentity.FieldUpdatedAt:
			if value, ok := values[i].(*sql.NullTime); !ok {
				return fmt.Errorf("unexpected type %T for field updated_at", values[i])
			} else if value.Valid {
				ui.UpdatedAt = value.Time
			}
		case useridentity.FieldIss:
			if value, ok := values[i].(*sql.NullString); !ok {
				return fmt.Errorf("unexpected type %T for field iss", values[i])
			} else if value.Valid {
				ui.Iss = value.String
			}
		case useridentity.FieldSub:
			if value, ok := values[i].(*sql.NullString); !ok {
				return fmt.Errorf("unexpected type %T for field sub", values[i])
			} else if value.Valid {
				ui.Sub = value.String
			}
		case useridentity.FieldEmail:
			if value, ok := values[i].(*sql.NullString); !ok {
				return fmt.Errorf("unexpected type %T for field email", values[i])
			} else if value.Valid {
				ui.Email = value.String
			}
		case useridentity.FieldEmailVerified:
			if value, ok := values[i].(*sql.NullBool); !ok {
				return fmt.Errorf("unexpected type %T for field email_verified", values[i])
			} else if value.Valid {
				ui.EmailVerified = value.Bool
			}
		case useridentity.FieldName:
			if value, ok := values[i].(*sql.NullString); !ok {
				return fmt.Errorf("unexpected type %T for field name", values[i])
			} else if value.Valid {
				ui.Name = new(string)
				*ui.Name = value.String
			}
		case useridentity.ForeignKeys[0]:
			if value, ok := values[i].(*sql.NullScanner); !ok {
				return fmt.Errorf("unexpected type %T for field user_id", values[i])
			} else if value.Valid {
				ui.user_id = new(uuid.UUID)
				*ui.user_id = *value.S.(*uuid.UUID)
			}
		default:
			ui.selectValues.Set(columns[i], values[i])
		}
	}
	return nil
}

// Value returns the ent.Value that was dynamically selected and assigned to the UserIdentity.
// This includes values selected through modifiers, order, etc.
func (ui *UserIdentity) Value(name string) (ent.Value, error) {
	return ui.selectValues.Get(name)
}

// QueryUser queries the "user" edge of the UserIdentity entity.
func (ui *UserIdentity) QueryUser() *UserQuery {
	return NewUserIdentityClient(ui.config).QueryUser(ui)
}

// Update returns a builder for updating this UserIdentity.
// Note that you need to call UserIdentity.Unwrap() before calling this method if this UserIdentity
// was returned from a transaction, and the transaction was committed or rolled back.
func (ui *UserIdentity) Update() *UserIdentityUpdateOne {
	return NewUserIdentityClient(ui.config).UpdateOne(ui)
}

// Unwrap unwraps the UserIdentity entity that was returned from a transaction after it was closed,
// so that all future queries will be executed through the driver which created the transaction.
func (ui *UserIdentity) Unwrap() *UserIdentity {
	_tx, ok := ui.config.driver.(*txDriver)
	if !ok {
		panic("ent: UserIdentity is not a transactional entity")
	}
	ui.config.driver = _tx.drv
	return ui
}

// String implements the fmt.Stringer.
func (ui *UserIdentity) String() string {
	var builder strings.Builder
	builder.WriteString("UserIdentity(")
	builder.WriteString(fmt.Sprintf("id=%v, ", ui.ID))
	builder.WriteString("created_at=")
	builder.WriteString(ui.CreatedAt.Format(time.ANSIC))
	builder.WriteString(", ")
	builder.WriteString("updated_at=")
	builder.WriteString(ui.UpdatedAt.Format(time.ANSIC))
	builder.WriteString(", ")
	builder.WriteString("iss=")
	builder.WriteString(ui.Iss)
	builder.WriteString(", ")
	builder.WriteString("sub=")
	builder.WriteString(ui.Sub)
	builder.WriteString(", ")
	builder.WriteString("email=")
	builder.WriteString(ui.Email)
	builder.WriteString(", ")
	builder.WriteString("email_verified=")
	builder.WriteString(fmt.Sprintf("%v", ui.EmailVerified))
	builder.WriteString(", ")
	if v := ui.Name; v != nil {
		builder.WriteString("name=")
		builder.WriteString(*v)
	}
	builder.WriteByte(')')
	return builder.String()
}

// UserIdentities is a parsable slice of UserIdentity.
type UserIdentities []*UserIdentity
