// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

public class SectionFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
}

public class SectionHeaderTitleFormItem: FormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}
	
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	public var title: String?

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}
}

public class SectionHeaderViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	public typealias CreateUIView = (Void) -> UIView?
	public var viewBlock: CreateUIView?
}

public class SectionFooterTitleFormItem: FormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}
	
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	public var title: String?

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}
}

public class SectionFooterViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visit(object: self)
	}
	
	public typealias CreateUIView = (Void) -> UIView?
	public var viewBlock: CreateUIView?
}
