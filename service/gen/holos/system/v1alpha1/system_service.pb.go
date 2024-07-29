// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.34.2
// 	protoc        (unknown)
// source: holos/system/v1alpha1/system_service.proto

package system

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	fieldmaskpb "google.golang.org/protobuf/types/known/fieldmaskpb"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type GetVersionRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	// FieldMask represents the fields to include in the response.
	FieldMask *fieldmaskpb.FieldMask `protobuf:"bytes,1,opt,name=field_mask,json=fieldMask,proto3" json:"field_mask,omitempty"`
}

func (x *GetVersionRequest) Reset() {
	*x = GetVersionRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *GetVersionRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*GetVersionRequest) ProtoMessage() {}

func (x *GetVersionRequest) ProtoReflect() protoreflect.Message {
	mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use GetVersionRequest.ProtoReflect.Descriptor instead.
func (*GetVersionRequest) Descriptor() ([]byte, []int) {
	return file_holos_system_v1alpha1_system_service_proto_rawDescGZIP(), []int{0}
}

func (x *GetVersionRequest) GetFieldMask() *fieldmaskpb.FieldMask {
	if x != nil {
		return x.FieldMask
	}
	return nil
}

type GetVersionResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Version *Version `protobuf:"bytes,1,opt,name=version,proto3" json:"version,omitempty"`
}

func (x *GetVersionResponse) Reset() {
	*x = GetVersionResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *GetVersionResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*GetVersionResponse) ProtoMessage() {}

func (x *GetVersionResponse) ProtoReflect() protoreflect.Message {
	mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use GetVersionResponse.ProtoReflect.Descriptor instead.
func (*GetVersionResponse) Descriptor() ([]byte, []int) {
	return file_holos_system_v1alpha1_system_service_proto_rawDescGZIP(), []int{1}
}

func (x *GetVersionResponse) GetVersion() *Version {
	if x != nil {
		return x.Version
	}
	return nil
}

type SeedDatabaseRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *SeedDatabaseRequest) Reset() {
	*x = SeedDatabaseRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[2]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *SeedDatabaseRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*SeedDatabaseRequest) ProtoMessage() {}

func (x *SeedDatabaseRequest) ProtoReflect() protoreflect.Message {
	mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[2]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use SeedDatabaseRequest.ProtoReflect.Descriptor instead.
func (*SeedDatabaseRequest) Descriptor() ([]byte, []int) {
	return file_holos_system_v1alpha1_system_service_proto_rawDescGZIP(), []int{2}
}

type SeedDatabaseResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *SeedDatabaseResponse) Reset() {
	*x = SeedDatabaseResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[3]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *SeedDatabaseResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*SeedDatabaseResponse) ProtoMessage() {}

func (x *SeedDatabaseResponse) ProtoReflect() protoreflect.Message {
	mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[3]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use SeedDatabaseResponse.ProtoReflect.Descriptor instead.
func (*SeedDatabaseResponse) Descriptor() ([]byte, []int) {
	return file_holos_system_v1alpha1_system_service_proto_rawDescGZIP(), []int{3}
}

type DropTablesRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *DropTablesRequest) Reset() {
	*x = DropTablesRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[4]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DropTablesRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DropTablesRequest) ProtoMessage() {}

func (x *DropTablesRequest) ProtoReflect() protoreflect.Message {
	mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[4]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DropTablesRequest.ProtoReflect.Descriptor instead.
func (*DropTablesRequest) Descriptor() ([]byte, []int) {
	return file_holos_system_v1alpha1_system_service_proto_rawDescGZIP(), []int{4}
}

type DropTablesResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *DropTablesResponse) Reset() {
	*x = DropTablesResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[5]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DropTablesResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DropTablesResponse) ProtoMessage() {}

func (x *DropTablesResponse) ProtoReflect() protoreflect.Message {
	mi := &file_holos_system_v1alpha1_system_service_proto_msgTypes[5]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DropTablesResponse.ProtoReflect.Descriptor instead.
func (*DropTablesResponse) Descriptor() ([]byte, []int) {
	return file_holos_system_v1alpha1_system_service_proto_rawDescGZIP(), []int{5}
}

var File_holos_system_v1alpha1_system_service_proto protoreflect.FileDescriptor

var file_holos_system_v1alpha1_system_service_proto_rawDesc = []byte{
	0x0a, 0x2a, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2f, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2f, 0x76,
	0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x2f, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x5f, 0x73,
	0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x15, 0x68, 0x6f,
	0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2e, 0x76, 0x31, 0x61, 0x6c, 0x70,
	0x68, 0x61, 0x31, 0x1a, 0x20, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2f, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x62, 0x75, 0x66, 0x2f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x5f, 0x6d, 0x61, 0x73, 0x6b, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x1a, 0x22, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2f, 0x73, 0x79, 0x73,
	0x74, 0x65, 0x6d, 0x2f, 0x76, 0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x2f, 0x73, 0x79, 0x73,
	0x74, 0x65, 0x6d, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0x4e, 0x0a, 0x11, 0x47, 0x65, 0x74,
	0x56, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x39,
	0x0a, 0x0a, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x5f, 0x6d, 0x61, 0x73, 0x6b, 0x18, 0x01, 0x20, 0x01,
	0x28, 0x0b, 0x32, 0x1a, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x4d, 0x61, 0x73, 0x6b, 0x52, 0x09,
	0x66, 0x69, 0x65, 0x6c, 0x64, 0x4d, 0x61, 0x73, 0x6b, 0x22, 0x4e, 0x0a, 0x12, 0x47, 0x65, 0x74,
	0x56, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x12,
	0x38, 0x0a, 0x07, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0b,
	0x32, 0x1e, 0x2e, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2e,
	0x76, 0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x2e, 0x56, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e,
	0x52, 0x07, 0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x22, 0x15, 0x0a, 0x13, 0x53, 0x65, 0x65,
	0x64, 0x44, 0x61, 0x74, 0x61, 0x62, 0x61, 0x73, 0x65, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74,
	0x22, 0x16, 0x0a, 0x14, 0x53, 0x65, 0x65, 0x64, 0x44, 0x61, 0x74, 0x61, 0x62, 0x61, 0x73, 0x65,
	0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x13, 0x0a, 0x11, 0x44, 0x72, 0x6f, 0x70,
	0x54, 0x61, 0x62, 0x6c, 0x65, 0x73, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x22, 0x14, 0x0a,
	0x12, 0x44, 0x72, 0x6f, 0x70, 0x54, 0x61, 0x62, 0x6c, 0x65, 0x73, 0x52, 0x65, 0x73, 0x70, 0x6f,
	0x6e, 0x73, 0x65, 0x32, 0xc4, 0x02, 0x0a, 0x0d, 0x53, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x53, 0x65,
	0x72, 0x76, 0x69, 0x63, 0x65, 0x12, 0x63, 0x0a, 0x0a, 0x47, 0x65, 0x74, 0x56, 0x65, 0x72, 0x73,
	0x69, 0x6f, 0x6e, 0x12, 0x28, 0x2e, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74,
	0x65, 0x6d, 0x2e, 0x76, 0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x2e, 0x47, 0x65, 0x74, 0x56,
	0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x29, 0x2e,
	0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2e, 0x76, 0x31, 0x61,
	0x6c, 0x70, 0x68, 0x61, 0x31, 0x2e, 0x47, 0x65, 0x74, 0x56, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e,
	0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12, 0x63, 0x0a, 0x0a, 0x44, 0x72,
	0x6f, 0x70, 0x54, 0x61, 0x62, 0x6c, 0x65, 0x73, 0x12, 0x28, 0x2e, 0x68, 0x6f, 0x6c, 0x6f, 0x73,
	0x2e, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2e, 0x76, 0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31,
	0x2e, 0x44, 0x72, 0x6f, 0x70, 0x54, 0x61, 0x62, 0x6c, 0x65, 0x73, 0x52, 0x65, 0x71, 0x75, 0x65,
	0x73, 0x74, 0x1a, 0x29, 0x2e, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74, 0x65,
	0x6d, 0x2e, 0x76, 0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x2e, 0x44, 0x72, 0x6f, 0x70, 0x54,
	0x61, 0x62, 0x6c, 0x65, 0x73, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12,
	0x69, 0x0a, 0x0c, 0x53, 0x65, 0x65, 0x64, 0x44, 0x61, 0x74, 0x61, 0x62, 0x61, 0x73, 0x65, 0x12,
	0x2a, 0x2e, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2e, 0x76,
	0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x2e, 0x53, 0x65, 0x65, 0x64, 0x44, 0x61, 0x74, 0x61,
	0x62, 0x61, 0x73, 0x65, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x2b, 0x2e, 0x68, 0x6f,
	0x6c, 0x6f, 0x73, 0x2e, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2e, 0x76, 0x31, 0x61, 0x6c, 0x70,
	0x68, 0x61, 0x31, 0x2e, 0x53, 0x65, 0x65, 0x64, 0x44, 0x61, 0x74, 0x61, 0x62, 0x61, 0x73, 0x65,
	0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x42, 0x45, 0x5a, 0x43, 0x67, 0x69,
	0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2d, 0x72,
	0x75, 0x6e, 0x2f, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2f, 0x73, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65,
	0x2f, 0x67, 0x65, 0x6e, 0x2f, 0x68, 0x6f, 0x6c, 0x6f, 0x73, 0x2f, 0x73, 0x79, 0x73, 0x74, 0x65,
	0x6d, 0x2f, 0x76, 0x31, 0x61, 0x6c, 0x70, 0x68, 0x61, 0x31, 0x3b, 0x73, 0x79, 0x73, 0x74, 0x65,
	0x6d, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_holos_system_v1alpha1_system_service_proto_rawDescOnce sync.Once
	file_holos_system_v1alpha1_system_service_proto_rawDescData = file_holos_system_v1alpha1_system_service_proto_rawDesc
)

func file_holos_system_v1alpha1_system_service_proto_rawDescGZIP() []byte {
	file_holos_system_v1alpha1_system_service_proto_rawDescOnce.Do(func() {
		file_holos_system_v1alpha1_system_service_proto_rawDescData = protoimpl.X.CompressGZIP(file_holos_system_v1alpha1_system_service_proto_rawDescData)
	})
	return file_holos_system_v1alpha1_system_service_proto_rawDescData
}

var file_holos_system_v1alpha1_system_service_proto_msgTypes = make([]protoimpl.MessageInfo, 6)
var file_holos_system_v1alpha1_system_service_proto_goTypes = []any{
	(*GetVersionRequest)(nil),     // 0: holos.system.v1alpha1.GetVersionRequest
	(*GetVersionResponse)(nil),    // 1: holos.system.v1alpha1.GetVersionResponse
	(*SeedDatabaseRequest)(nil),   // 2: holos.system.v1alpha1.SeedDatabaseRequest
	(*SeedDatabaseResponse)(nil),  // 3: holos.system.v1alpha1.SeedDatabaseResponse
	(*DropTablesRequest)(nil),     // 4: holos.system.v1alpha1.DropTablesRequest
	(*DropTablesResponse)(nil),    // 5: holos.system.v1alpha1.DropTablesResponse
	(*fieldmaskpb.FieldMask)(nil), // 6: google.protobuf.FieldMask
	(*Version)(nil),               // 7: holos.system.v1alpha1.Version
}
var file_holos_system_v1alpha1_system_service_proto_depIdxs = []int32{
	6, // 0: holos.system.v1alpha1.GetVersionRequest.field_mask:type_name -> google.protobuf.FieldMask
	7, // 1: holos.system.v1alpha1.GetVersionResponse.version:type_name -> holos.system.v1alpha1.Version
	0, // 2: holos.system.v1alpha1.SystemService.GetVersion:input_type -> holos.system.v1alpha1.GetVersionRequest
	4, // 3: holos.system.v1alpha1.SystemService.DropTables:input_type -> holos.system.v1alpha1.DropTablesRequest
	2, // 4: holos.system.v1alpha1.SystemService.SeedDatabase:input_type -> holos.system.v1alpha1.SeedDatabaseRequest
	1, // 5: holos.system.v1alpha1.SystemService.GetVersion:output_type -> holos.system.v1alpha1.GetVersionResponse
	5, // 6: holos.system.v1alpha1.SystemService.DropTables:output_type -> holos.system.v1alpha1.DropTablesResponse
	3, // 7: holos.system.v1alpha1.SystemService.SeedDatabase:output_type -> holos.system.v1alpha1.SeedDatabaseResponse
	5, // [5:8] is the sub-list for method output_type
	2, // [2:5] is the sub-list for method input_type
	2, // [2:2] is the sub-list for extension type_name
	2, // [2:2] is the sub-list for extension extendee
	0, // [0:2] is the sub-list for field type_name
}

func init() { file_holos_system_v1alpha1_system_service_proto_init() }
func file_holos_system_v1alpha1_system_service_proto_init() {
	if File_holos_system_v1alpha1_system_service_proto != nil {
		return
	}
	file_holos_system_v1alpha1_system_proto_init()
	if !protoimpl.UnsafeEnabled {
		file_holos_system_v1alpha1_system_service_proto_msgTypes[0].Exporter = func(v any, i int) any {
			switch v := v.(*GetVersionRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_holos_system_v1alpha1_system_service_proto_msgTypes[1].Exporter = func(v any, i int) any {
			switch v := v.(*GetVersionResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_holos_system_v1alpha1_system_service_proto_msgTypes[2].Exporter = func(v any, i int) any {
			switch v := v.(*SeedDatabaseRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_holos_system_v1alpha1_system_service_proto_msgTypes[3].Exporter = func(v any, i int) any {
			switch v := v.(*SeedDatabaseResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_holos_system_v1alpha1_system_service_proto_msgTypes[4].Exporter = func(v any, i int) any {
			switch v := v.(*DropTablesRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_holos_system_v1alpha1_system_service_proto_msgTypes[5].Exporter = func(v any, i int) any {
			switch v := v.(*DropTablesResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_holos_system_v1alpha1_system_service_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   6,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_holos_system_v1alpha1_system_service_proto_goTypes,
		DependencyIndexes: file_holos_system_v1alpha1_system_service_proto_depIdxs,
		MessageInfos:      file_holos_system_v1alpha1_system_service_proto_msgTypes,
	}.Build()
	File_holos_system_v1alpha1_system_service_proto = out.File
	file_holos_system_v1alpha1_system_service_proto_rawDesc = nil
	file_holos_system_v1alpha1_system_service_proto_goTypes = nil
	file_holos_system_v1alpha1_system_service_proto_depIdxs = nil
}
