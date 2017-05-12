import CPerl

public struct PerlInterpreter {
	public typealias Pointee = CPerl.PerlInterpreter
	public typealias Pointer = UnsafeMutablePointer<Pointee>

	let pointer: Pointer

	var pointee: Pointee {
		unsafeAddress {
			return UnsafePointer(pointer)
		}
		nonmutating unsafeMutableAddress {
			return pointer
		}
	}

	init(_ pointer: Pointer) {
		self.pointer = pointer
	}

	/// A Perl interpreter stored in the thread local storage.
	public static var current: PerlInterpreter {
		get { return PerlInterpreter(PERL_GET_THX()) }
		set { PERL_SET_THX(newValue.pointer) }
	}

	/// The main Perl interpreter of the process.
	public static var main: PerlInterpreter {
		get { return PerlInterpreter(PERL_GET_INTERP()) }
		set { PERL_SET_INTERP(newValue.pointer) }
	}

	var error: UnsafeSvContext {
		return UnsafeSvContext(sv: pointee.ERRSV, perl: self)
	}

	/// Loads the module by name.
	/// It is analogous to Perl code `eval "require $module"` and even implemented that way.
	public func require(_ module: String) throws {
		try eval("require \(module)")
	}

	/// Loads the module by its file name.
	/// It is analogous to Perl code `eval "require '$file'"` and even implemented that way.
	public func require(file: String) throws {
		try eval("require q\0\(file)\0")
	}

	/// Returns the SV of the specified Perl scalar.
	/// If `GV_ADD` is set in `flags` and the Perl variable does not exist then it will be created.
	/// If `flags` is zero and the variable does not exist then `nil` is returned.
	public func getSV(_ name: String, flags: Int32 = 0) -> UnsafeSvPointer? {
		return pointee.get_sv(name, SVf_UTF8|flags)
	}

	/// Returns the AV of the specified Perl array.
	/// If `GV_ADD` is set in `flags` and the Perl variable does not exist then it will be created.
	/// If `flags` is zero and the variable does not exist then `nil` is returned.
	public func getAV(_ name: String, flags: Int32 = 0) -> UnsafeAvPointer? {
		return pointee.get_av(name, SVf_UTF8|flags)
	}

	/// Returns the HV of the specified Perl hash.
	/// If `GV_ADD` is set in `flags` and the Perl variable does not exist then it will be created.
	/// If `flags` is zero and the variable does not exist then `nil` is returned.
	public func getHV(_ name: String, flags: Int32 = 0) -> UnsafeHvPointer? {
		return pointee.get_hv(name, SVf_UTF8|flags)
	}

	/// Returns the CV of the specified Perl subroutine.
	/// If `GV_ADD` is set in `flags` and the Perl subroutine does not exist then it will be declared
	/// (which has the same effect as saying `sub name;`).
	/// If `GV_ADD` is not set and the subroutine does not exist then `nil` is returned.
	public func getCV(_ name: String, flags: Int32 = 0) -> UnsafeCvPointer? {
		return pointee.get_cv(name, SVf_UTF8|flags)
	}
}
