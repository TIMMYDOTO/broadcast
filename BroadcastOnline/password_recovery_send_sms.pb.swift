// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: rpc/password_recovery/password_recovery_send_sms.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Bb_PasswordRecoverySendSmsRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var captchaKey: String = String()

  var captcha: String = String()

  var phone: String = String()

  var birthDate: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Bb_PasswordRecoverySendSmsResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var code: Int32 = 0

  var status: String = String()

  var error: Bb_Error {
    get {return _error ?? Bb_Error()}
    set {_error = newValue}
  }
  /// Returns true if `error` has been explicitly set.
  var hasError: Bool {return self._error != nil}
  /// Clears the value of `error`. Subsequent reads from it will return its default value.
  mutating func clearError() {self._error = nil}

  var sessionID: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _error: Bb_Error? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "bb"

extension Bb_PasswordRecoverySendSmsRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PasswordRecoverySendSmsRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "captcha_key"),
    2: .same(proto: "captcha"),
    3: .same(proto: "phone"),
    4: .standard(proto: "birth_date"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.captchaKey) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.captcha) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.phone) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.birthDate) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.captchaKey.isEmpty {
      try visitor.visitSingularStringField(value: self.captchaKey, fieldNumber: 1)
    }
    if !self.captcha.isEmpty {
      try visitor.visitSingularStringField(value: self.captcha, fieldNumber: 2)
    }
    if !self.phone.isEmpty {
      try visitor.visitSingularStringField(value: self.phone, fieldNumber: 3)
    }
    if !self.birthDate.isEmpty {
      try visitor.visitSingularStringField(value: self.birthDate, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_PasswordRecoverySendSmsRequest, rhs: Bb_PasswordRecoverySendSmsRequest) -> Bool {
    if lhs.captchaKey != rhs.captchaKey {return false}
    if lhs.captcha != rhs.captcha {return false}
    if lhs.phone != rhs.phone {return false}
    if lhs.birthDate != rhs.birthDate {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Bb_PasswordRecoverySendSmsResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PasswordRecoverySendSmsResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "code"),
    2: .same(proto: "status"),
    3: .same(proto: "error"),
    4: .standard(proto: "session_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.code) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.status) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._error) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.sessionID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.code != 0 {
      try visitor.visitSingularInt32Field(value: self.code, fieldNumber: 1)
    }
    if !self.status.isEmpty {
      try visitor.visitSingularStringField(value: self.status, fieldNumber: 2)
    }
    if let v = self._error {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }
    if !self.sessionID.isEmpty {
      try visitor.visitSingularStringField(value: self.sessionID, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_PasswordRecoverySendSmsResponse, rhs: Bb_PasswordRecoverySendSmsResponse) -> Bool {
    if lhs.code != rhs.code {return false}
    if lhs.status != rhs.status {return false}
    if lhs._error != rhs._error {return false}
    if lhs.sessionID != rhs.sessionID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
