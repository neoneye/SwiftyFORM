//
//  SectionFormItem.swift
//  SwiftyFORM
//
//  Created by Simon Strandgaard on 20-06-15.
//  Copyright © 2015 Simon Strandgaard. All rights reserved.
//

import Foundation

public class SectionFormItem: FormItem {
	override func accept(visitor: FormItemVisitor) {
		visitor.visitSection(self)
	}
}

public class SectionHeaderTitleFormItem: FormItem {
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
