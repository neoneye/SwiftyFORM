// MIT license. Copyright (c) 2015 SwiftyFORM. All rights reserved.
import Foundation

public class SectionFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSection(self)
	}
}

public class SectionHeaderTitleFormItem: FormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}
	
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSectionHeaderTitle(self)
	}
	
	public var title: String?
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
}

public class SectionHeaderViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSectionHeaderView(self)
	}
	
	public typealias CreateUIView = Void -> UIView?
	public var viewBlock: CreateUIView?
}

public class SectionFooterTitleFormItem: FormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}
	
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSectionFooterTitle(self)
	}
	
	public var title: String?
	public func title(title: String) -> Self {
		self.title = title
		return self
	}
}

public class SectionFooterViewFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSectionFooterView(self)
	}
	
	public typealias CreateUIView = Void -> UIView?
	public var viewBlock: CreateUIView?
}
