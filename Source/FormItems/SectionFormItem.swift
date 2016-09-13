// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

open class SectionFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
}

open class SectionHeaderTitleFormItem: FormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}
	
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String?
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
}

open class SectionHeaderViewFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public typealias CreateUIView = (Void) -> UIView?
	open var viewBlock: CreateUIView?
}

open class SectionFooterTitleFormItem: FormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}
	
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	open var title: String?
	open func title(_ title: String) -> Self {
		self.title = title
		return self
	}
}

open class SectionFooterViewFormItem: FormItem {
	override func accept(_ visitor: FormItemVisitor) {
		visitor.visit(self)
	}
	
	public typealias CreateUIView = (Void) -> UIView?
	open var viewBlock: CreateUIView?
}
