// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: tournament.proto
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

struct Bb_Mobile_SportTreeWs_Tournament {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var info: Bb_Mobile_SportTreeWs_Tournament.TournamentInfo {
    get {return _info ?? Bb_Mobile_SportTreeWs_Tournament.TournamentInfo()}
    set {_info = newValue}
  }
  /// Returns true if `info` has been explicitly set.
  var hasInfo: Bool {return self._info != nil}
  /// Clears the value of `info`. Subsequent reads from it will return its default value.
  mutating func clearInfo() {self._info = nil}

  var matches: [Bb_Mobile_SportTreeWs_Match] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  struct TournamentInfo {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var id: Int32 = 0

    var gid: String = String()

    var name: String = String()

    var order: Int32 = 0

    var sportID: Int32 = 0

    var sportGid: String = String()

    var championshipID: Int32 = 0

    var championshipGid: String = String()

    var championshipName: String = String()

    var championshipOrder: Int32 = 0

    var hasLiveTvMatch_p: Bool = false

    var hasLiveInfoMatch_p: Bool = false

    var matchesCount: Int32 = 0

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
  }

  init() {}

  fileprivate var _info: Bb_Mobile_SportTreeWs_Tournament.TournamentInfo? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "bb.mobile.sport_tree_ws"

extension Bb_Mobile_SportTreeWs_Tournament: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Tournament"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "info"),
    2: .same(proto: "matches"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._info)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.matches)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._info {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.matches.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.matches, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_Mobile_SportTreeWs_Tournament, rhs: Bb_Mobile_SportTreeWs_Tournament) -> Bool {
    if lhs._info != rhs._info {return false}
    if lhs.matches != rhs.matches {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Bb_Mobile_SportTreeWs_Tournament.TournamentInfo: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = Bb_Mobile_SportTreeWs_Tournament.protoMessageName + ".TournamentInfo"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "gid"),
    3: .same(proto: "name"),
    4: .same(proto: "order"),
    5: .standard(proto: "sport_id"),
    6: .standard(proto: "sport_gid"),
    7: .standard(proto: "championship_id"),
    8: .standard(proto: "championship_gid"),
    9: .standard(proto: "championship_name"),
    10: .standard(proto: "championship_order"),
    11: .standard(proto: "has_live_tv_match"),
    12: .standard(proto: "has_live_info_match"),
    13: .standard(proto: "matches_count"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.id)
      case 2: try decoder.decodeSingularStringField(value: &self.gid)
      case 3: try decoder.decodeSingularStringField(value: &self.name)
      case 4: try decoder.decodeSingularInt32Field(value: &self.order)
      case 5: try decoder.decodeSingularInt32Field(value: &self.sportID)
      case 6: try decoder.decodeSingularStringField(value: &self.sportGid)
      case 7: try decoder.decodeSingularInt32Field(value: &self.championshipID)
      case 8: try decoder.decodeSingularStringField(value: &self.championshipGid)
      case 9: try decoder.decodeSingularStringField(value: &self.championshipName)
      case 11: try decoder.decodeSingularBoolField(value: &self.hasLiveTvMatch_p)
      case 12: try decoder.decodeSingularBoolField(value: &self.hasLiveInfoMatch_p)
      case 13: try decoder.decodeSingularInt32Field(value: &self.matchesCount)
      case 10: try decoder.decodeSingularInt32Field(value: &self.championshipOrder)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.id != 0 {
      try visitor.visitSingularInt32Field(value: self.id, fieldNumber: 1)
    }
    if !self.gid.isEmpty {
      try visitor.visitSingularStringField(value: self.gid, fieldNumber: 2)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 3)
    }
    if self.order != 0 {
      try visitor.visitSingularInt32Field(value: self.order, fieldNumber: 4)
    }
    if self.sportID != 0 {
      try visitor.visitSingularInt32Field(value: self.sportID, fieldNumber: 5)
    }
    if !self.sportGid.isEmpty {
      try visitor.visitSingularStringField(value: self.sportGid, fieldNumber: 6)
    }
    if self.championshipID != 0 {
      try visitor.visitSingularInt32Field(value: self.championshipID, fieldNumber: 7)
    }
    if !self.championshipGid.isEmpty {
      try visitor.visitSingularStringField(value: self.championshipGid, fieldNumber: 8)
    }
    if !self.championshipName.isEmpty {
      try visitor.visitSingularStringField(value: self.championshipName, fieldNumber: 9)
    }
    if self.hasLiveTvMatch_p != false {
      try visitor.visitSingularBoolField(value: self.hasLiveTvMatch_p, fieldNumber: 11)
    }
    if self.hasLiveInfoMatch_p != false {
      try visitor.visitSingularBoolField(value: self.hasLiveInfoMatch_p, fieldNumber: 12)
    }
    if self.matchesCount != 0 {
      try visitor.visitSingularInt32Field(value: self.matchesCount, fieldNumber: 13)
    }
    if self.championshipOrder != 0 {
      try visitor.visitSingularInt32Field(value: self.championshipOrder, fieldNumber: 10)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Bb_Mobile_SportTreeWs_Tournament.TournamentInfo, rhs: Bb_Mobile_SportTreeWs_Tournament.TournamentInfo) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.gid != rhs.gid {return false}
    if lhs.name != rhs.name {return false}
    if lhs.order != rhs.order {return false}
    if lhs.sportID != rhs.sportID {return false}
    if lhs.sportGid != rhs.sportGid {return false}
    if lhs.championshipID != rhs.championshipID {return false}
    if lhs.championshipGid != rhs.championshipGid {return false}
    if lhs.championshipName != rhs.championshipName {return false}
    if lhs.championshipOrder != rhs.championshipOrder {return false}
    if lhs.hasLiveTvMatch_p != rhs.hasLiveTvMatch_p {return false}
    if lhs.hasLiveInfoMatch_p != rhs.hasLiveInfoMatch_p {return false}
    if lhs.matchesCount != rhs.matchesCount {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
