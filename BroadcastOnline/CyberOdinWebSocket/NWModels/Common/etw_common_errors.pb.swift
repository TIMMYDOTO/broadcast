// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: common/common_errors.proto
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

struct Bb_Mobile_OddinTreeWs_Error {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var message: String = String()

  var details: SwiftProtobuf.Google_Protobuf_Any {
    get {return _details ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_details = newValue}
  }
  /// Returns true if `details` has been explicitly set.
  var hasDetails: Bool {return self._details != nil}
  /// Clears the value of `details`. Subsequent reads from it will return its default value.
  mutating func clearDetails() {self._details = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _details: SwiftProtobuf.Google_Protobuf_Any? = nil
}

struct Bb_Mobile_OddinTreeWs_BadRequestErrorDetails {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var violations: [Bb_Mobile_OddinTreeWs_BadRequestErrorDetails.Violation] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  struct Violation {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var reason: String = String()

    var message: String = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
  }

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "bb.mobile.oddin_tree_ws"

extension Bb_Mobile_OddinTreeWs_Error: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Error"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "message"),
    2: .same(proto: "details"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.message) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._details) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.message.isEmpty {
      try visitor.visitSingularStringField(value: self.message, fieldNumber: 1)
    }
    if let v = self._details {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_Mobile_OddinTreeWs_Error, rhs: Bb_Mobile_OddinTreeWs_Error) -> Bool {
    if lhs.message != rhs.message {return false}
    if lhs._details != rhs._details {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Bb_Mobile_OddinTreeWs_BadRequestErrorDetails: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".BadRequestErrorDetails"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "violations"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.violations) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.violations.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.violations, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_Mobile_OddinTreeWs_BadRequestErrorDetails, rhs: Bb_Mobile_OddinTreeWs_BadRequestErrorDetails) -> Bool {
    if lhs.violations != rhs.violations {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Bb_Mobile_OddinTreeWs_BadRequestErrorDetails.Violation: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = Bb_Mobile_OddinTreeWs_BadRequestErrorDetails.protoMessageName + ".Violation"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "reason"),
    2: .same(proto: "message"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.reason) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.message) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.reason.isEmpty {
      try visitor.visitSingularStringField(value: self.reason, fieldNumber: 1)
    }
    if !self.message.isEmpty {
      try visitor.visitSingularStringField(value: self.message, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_Mobile_OddinTreeWs_BadRequestErrorDetails.Violation, rhs: Bb_Mobile_OddinTreeWs_BadRequestErrorDetails.Violation) -> Bool {
    if lhs.reason != rhs.reason {return false}
    if lhs.message != rhs.message {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
