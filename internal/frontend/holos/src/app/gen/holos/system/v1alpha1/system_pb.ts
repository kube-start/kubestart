// @generated by protoc-gen-es v1.10.0 with parameter "target=ts"
// @generated from file holos/system/v1alpha1/system.proto (package holos.system.v1alpha1, syntax proto3)
/* eslint-disable */
// @ts-nocheck

import type { BinaryReadOptions, FieldList, JsonReadOptions, JsonValue, PartialMessage, PlainMessage } from "@bufbuild/protobuf";
import { Message, proto3 } from "@bufbuild/protobuf";

/**
 * @generated from message holos.system.v1alpha1.Version
 */
export class Version extends Message<Version> {
  /**
   * @generated from field: string version = 1;
   */
  version = "";

  /**
   * @generated from field: string git_commit = 2;
   */
  gitCommit = "";

  /**
   * @generated from field: string git_tree_state = 3;
   */
  gitTreeState = "";

  /**
   * @generated from field: string go_version = 4;
   */
  goVersion = "";

  /**
   * @generated from field: string build_date = 5;
   */
  buildDate = "";

  /**
   * @generated from field: string os = 6;
   */
  os = "";

  /**
   * @generated from field: string arch = 7;
   */
  arch = "";

  constructor(data?: PartialMessage<Version>) {
    super();
    proto3.util.initPartial(data, this);
  }

  static readonly runtime: typeof proto3 = proto3;
  static readonly typeName = "holos.system.v1alpha1.Version";
  static readonly fields: FieldList = proto3.util.newFieldList(() => [
    { no: 1, name: "version", kind: "scalar", T: 9 /* ScalarType.STRING */ },
    { no: 2, name: "git_commit", kind: "scalar", T: 9 /* ScalarType.STRING */ },
    { no: 3, name: "git_tree_state", kind: "scalar", T: 9 /* ScalarType.STRING */ },
    { no: 4, name: "go_version", kind: "scalar", T: 9 /* ScalarType.STRING */ },
    { no: 5, name: "build_date", kind: "scalar", T: 9 /* ScalarType.STRING */ },
    { no: 6, name: "os", kind: "scalar", T: 9 /* ScalarType.STRING */ },
    { no: 7, name: "arch", kind: "scalar", T: 9 /* ScalarType.STRING */ },
  ]);

  static fromBinary(bytes: Uint8Array, options?: Partial<BinaryReadOptions>): Version {
    return new Version().fromBinary(bytes, options);
  }

  static fromJson(jsonValue: JsonValue, options?: Partial<JsonReadOptions>): Version {
    return new Version().fromJson(jsonValue, options);
  }

  static fromJsonString(jsonString: string, options?: Partial<JsonReadOptions>): Version {
    return new Version().fromJsonString(jsonString, options);
  }

  static equals(a: Version | PlainMessage<Version> | undefined, b: Version | PlainMessage<Version> | undefined): boolean {
    return proto3.util.equals(Version, a, b);
  }
}

