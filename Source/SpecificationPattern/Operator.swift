/*
And operator - shorthand for .and()

USAGE:
let spec = onlyDigits & between2And4Letters & modulus13Checksum
*/
public func & (left: Specification, right: Specification) -> Specification {
	return left.and(right)
}

/*
Or operator - shorthand for .or()

USAGE:
let spec = connectionTypeWifi | connectionType4G | hasOfflineData
*/
public func | (left: Specification, right: Specification) -> Specification {
	return left.or(right)
}

/*
Negate operator - shorthand for .not()

USAGE:
let spec = ! filesystemIsFull
*/
public prefix func ! (specification: Specification) -> Specification {
	return specification.not()
}


/*
Equivalence operators - shorthand for .isSatisfiedBy()

USAGE:
spec == "123"
spec != "123"
*/
public func == (left: Specification, right: Any?) -> Bool {
	return left.isSatisfiedBy(right)
}
public func != (left: Specification, right: Any?) -> Bool {
	return !left.isSatisfiedBy(right)
}
