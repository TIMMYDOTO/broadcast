// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: register_check_sms.proto
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

struct Bb_RegisterCheckSmsRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var sessionID: String = String()

  var smsCode: String = String()

  var appsflyerID: String = String()

  var utmSource: String = String()

  var utmMedium: String = String()

  var utmCampaign: String = String()

  var utmContent: String = String()

  var utmSecret: String = String()

  var utmCode: String = String()

  var utmPid: String = String()

  var ymID: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Bb_RegisterCheckSmsResponse {
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

  var state: String = String()

  var gamblerID: Int32 = 0

  var userStatus: String = String()

  var token: String = String()

  var refreshToken: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _error: Bb_Error? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Bb_RegisterCheckSmsRequest: @unchecked Sendable {}
extension Bb_RegisterCheckSmsResponse: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "bb"

extension Bb_RegisterCheckSmsRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".RegisterCheckSmsRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "session_id"),
    2: .standard(proto: "sms_code"),
    3: .standard(proto: "appsflyer_id"),
    4: .standard(proto: "utm_source"),
    5: .standard(proto: "utm_medium"),
    6: .standard(proto: "utm_campaign"),
    7: .standard(proto: "utm_content"),
    8: .standard(proto: "utm_secret"),
    9: .standard(proto: "utm_code"),
    10: .standard(proto: "utm_pid"),
    11: .standard(proto: "ym_id"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.sessionID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.smsCode) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.appsflyerID) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.utmSource) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.utmMedium) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.utmCampaign) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.utmContent) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.utmSecret) }()
      case 9: try { try decoder.decodeSingularStringField(value: &self.utmCode) }()
      case 10: try { try decoder.decodeSingularStringField(value: &self.utmPid) }()
      case 11: try { try decoder.decodeSingularStringField(value: &self.ymID) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.sessionID.isEmpty {
      try visitor.visitSingularStringField(value: self.sessionID, fieldNumber: 1)
    }
    if !self.smsCode.isEmpty {
      try visitor.visitSingularStringField(value: self.smsCode, fieldNumber: 2)
    }
    if !self.appsflyerID.isEmpty {
      try visitor.visitSingularStringField(value: self.appsflyerID, fieldNumber: 3)
    }
    if !self.utmSource.isEmpty {
      try visitor.visitSingularStringField(value: self.utmSource, fieldNumber: 4)
    }
    if !self.utmMedium.isEmpty {
      try visitor.visitSingularStringField(value: self.utmMedium, fieldNumber: 5)
    }
    if !self.utmCampaign.isEmpty {
      try visitor.visitSingularStringField(value: self.utmCampaign, fieldNumber: 6)
    }
    if !self.utmContent.isEmpty {
      try visitor.visitSingularStringField(value: self.utmContent, fieldNumber: 7)
    }
    if !self.utmSecret.isEmpty {
      try visitor.visitSingularStringField(value: self.utmSecret, fieldNumber: 8)
    }
    if !self.utmCode.isEmpty {
      try visitor.visitSingularStringField(value: self.utmCode, fieldNumber: 9)
    }
    if !self.utmPid.isEmpty {
      try visitor.visitSingularStringField(value: self.utmPid, fieldNumber: 10)
    }
    if !self.ymID.isEmpty {
      try visitor.visitSingularStringField(value: self.ymID, fieldNumber: 11)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_RegisterCheckSmsRequest, rhs: Bb_RegisterCheckSmsRequest) -> Bool {
    if lhs.sessionID != rhs.sessionID {return false}
    if lhs.smsCode != rhs.smsCode {return false}
    if lhs.appsflyerID != rhs.appsflyerID {return false}
    if lhs.utmSource != rhs.utmSource {return false}
    if lhs.utmMedium != rhs.utmMedium {return false}
    if lhs.utmCampaign != rhs.utmCampaign {return false}
    if lhs.utmContent != rhs.utmContent {return false}
    if lhs.utmSecret != rhs.utmSecret {return false}
    if lhs.utmCode != rhs.utmCode {return false}
    if lhs.utmPid != rhs.utmPid {return false}
    if lhs.ymID != rhs.ymID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Bb_RegisterCheckSmsResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".RegisterCheckSmsResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "code"),
    2: .same(proto: "status"),
    3: .same(proto: "error"),
    4: .same(proto: "state"),
    5: .standard(proto: "gambler_id"),
    6: .standard(proto: "user_status"),
    7: .same(proto: "token"),
    8: .standard(proto: "refresh_token"),
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
      case 4: try { try decoder.decodeSingularStringField(value: &self.state) }()
      case 5: try { try decoder.decodeSingularInt32Field(value: &self.gamblerID) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.userStatus) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.token) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.refreshToken) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.code != 0 {
      try visitor.visitSingularInt32Field(value: self.code, fieldNumber: 1)
    }
    if !self.status.isEmpty {
      try visitor.visitSingularStringField(value: self.status, fieldNumber: 2)
    }
    try { if let v = self._error {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    if !self.state.isEmpty {
      try visitor.visitSingularStringField(value: self.state, fieldNumber: 4)
    }
    if self.gamblerID != 0 {
      try visitor.visitSingularInt32Field(value: self.gamblerID, fieldNumber: 5)
    }
    if !self.userStatus.isEmpty {
      try visitor.visitSingularStringField(value: self.userStatus, fieldNumber: 6)
    }
    if !self.token.isEmpty {
      try visitor.visitSingularStringField(value: self.token, fieldNumber: 7)
    }
    if !self.refreshToken.isEmpty {
      try visitor.visitSingularStringField(value: self.refreshToken, fieldNumber: 8)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_RegisterCheckSmsResponse, rhs: Bb_RegisterCheckSmsResponse) -> Bool {
    if lhs.code != rhs.code {return false}
    if lhs.status != rhs.status {return false}
    if lhs._error != rhs._error {return false}
    if lhs.state != rhs.state {return false}
    if lhs.gamblerID != rhs.gamblerID {return false}
    if lhs.userStatus != rhs.userStatus {return false}
    if lhs.token != rhs.token {return false}
    if lhs.refreshToken != rhs.refreshToken {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
