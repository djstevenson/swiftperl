/// Enumeration of the possible errors.
public enum PerlError : Error {
	/// A `die` occurred in Perl. Text of the error or a SV die was called with
	/// will be in an associated value.
	case died(_: PerlSV)

	/// An undefined value was received in place not supposed to.
	case unexpectedUndef(_: AnyPerl)

	/// SV of an unexpected type was recevied.
	case unexpectedSvType(_: AnyPerl, want: SvType)

	/// SV is not an object, but we suppose it to be.
	case notObject(_: AnyPerl)

	/// SV is not a wrapped Swift object, but we suppose it to be.
	case notSwiftObject(_: AnyPerl)

	/// SV bridges to an object of an unexpected type.
	case unexpectedObjectType(_: AnyPerl, want: AnyPerl.Type)
}
