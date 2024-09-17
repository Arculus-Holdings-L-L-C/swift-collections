//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Collections open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

extension UnsafeMutableBufferPointer {
  @inlinable
  public func initialize(fromContentsOf source: Self) -> Index {
    guard source.count > 0 else { return 0 }
    precondition(
      source.count <= self.count,
      "buffer cannot contain every element from source.")
    baseAddress.unsafelyUnwrapped.initialize(
      from: source.baseAddress.unsafelyUnwrapped,
      count: source.count)
    return source.count
  }

  @inlinable
  public func initialize(fromContentsOf source: Slice<Self>) -> Index {
    let sourceCount = source.count
    guard sourceCount > 0 else { return 0 }
    precondition(
      sourceCount <= self.count,
      "buffer cannot contain every element from source.")
    baseAddress.unsafelyUnwrapped.initialize(
      from: source.base.baseAddress.unsafelyUnwrapped + source.startIndex,
      count: sourceCount)
    return sourceCount
  }
}

extension Slice {
  @inlinable @inline(__always)
  public func initialize<Element>(
    fromContentsOf source: UnsafeMutableBufferPointer<Element>
  ) -> Index
  where Base == UnsafeMutableBufferPointer<Element>
  {
    let target = UnsafeMutableBufferPointer(rebasing: self)
    let i = target.initialize(fromContentsOf: source)
    return self.startIndex + i
  }

  @inlinable @inline(__always)
  public func initialize<Element>(
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>
  ) -> Index
  where Base == UnsafeMutableBufferPointer<Element>
  {
    let target = UnsafeMutableBufferPointer(rebasing: self)
    let i = target.initialize(fromContentsOf: source)
    return self.startIndex + i
  }
}

extension UnsafeMutableBufferPointer {
  @inlinable @inline(__always)
  public func initializeAll<C: Collection>(
    fromContentsOf source: C
  ) where C.Element == Element {
    let i = self.initialize(fromContentsOf: source)
    assert(i == self.endIndex)
  }

  @inlinable @inline(__always)
  public func initializeAll(fromContentsOf source: Self) {
    let i = self.initialize(fromContentsOf: source)
    assert(i == self.endIndex)
  }

  @inlinable @inline(__always)
  public func initializeAll(fromContentsOf source: Slice<Self>) {
    let i = self.initialize(fromContentsOf: source)
    assert(i == self.endIndex)
  }

  @inlinable @inline(__always)
  public func moveInitializeAll(fromContentsOf source: Self) {
    let i = self.moveInitialize(fromContentsOf: source)
    assert(i == self.endIndex)
  }

  @inlinable @inline(__always)
  public func moveInitializeAll(fromContentsOf source: Slice<Self>) {
    let i = self.moveInitialize(fromContentsOf: source)
    assert(i == self.endIndex)
  }
}

extension Slice {
  @inlinable @inline(__always)
  public func initializeAll<C: Collection>(
    fromContentsOf source: C
  ) where Base == UnsafeMutableBufferPointer<C.Element> {
    let i = self.initializeSlice(fromContentsOf: source)
    assert(i == self.endIndex)
  }

  @inlinable @inline(__always)
  public func initializeAll<Element>(
    fromContentsOf source: UnsafeMutableBufferPointer<Element>
  ) where Base == UnsafeMutableBufferPointer<Element> {
    let target = UnsafeMutableBufferPointer(rebasing: self)
    target.initializeAll(fromContentsOf: source)
  }

  @inlinable @inline(__always)
  public func initializeAll<Element>(
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>
  ) where Base == UnsafeMutableBufferPointer<Element> {
    let target = UnsafeMutableBufferPointer(rebasing: self)
    target.initializeAll(fromContentsOf: source)
  }

  @inlinable @inline(__always)
  public func moveInitializeAll<Element>(
    fromContentsOf source: UnsafeMutableBufferPointer<Element>
  ) where Base == UnsafeMutableBufferPointer<Element> {
    let target = UnsafeMutableBufferPointer(rebasing: self)
    target.moveInitializeAll(fromContentsOf: source)
  }

  @inlinable @inline(__always)
  public func moveInitializeAll<Element>(
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>
  ) where Base == UnsafeMutableBufferPointer<Element> {
    let target = UnsafeMutableBufferPointer(rebasing: self)
    target.moveInitializeAll(fromContentsOf: source)
  }
}
