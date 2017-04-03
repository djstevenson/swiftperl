import PackageDescription
import Glibc

let buildBenchmark = false

let package = Package(
	name: "Perl",
	targets: [
		Target(name: "CPerl"),
		Target(name: "Perl", dependencies: [.Target(name: "CPerl")]),
		Target(name: "SampleXS", dependencies: [.Target(name: "Perl")])
	]
)

if buildBenchmark {
	package.targets.append(Target(name: "swiftperl-benchmark", dependencies: [.Target(name: "Perl")]))
	package.dependencies.append(.Package(url: "https://github.com/my-mail-ru/swift-Benchmark.git", majorVersion: 0))
} else {
	package.exclude.append("Sources/swiftperl-benchmark")
}

products.append(Product(name: "SampleXS", type: .Library(.Dynamic), modules: "SampleXS"))

func getenv(_ name: String) -> String? {
	guard let value = Glibc.getenv(name) else { return nil }
	return String(cString: value)
}

// Taken from swift-package-manager
let tmpdir = getenv("TMPDIR") ?? getenv("TEMP") ?? getenv("TMP") ?? "/tmp/"

let me = CommandLine.arguments[0]
if me[me.startIndex..<min(me.endIndex, tmpdir.endIndex)] != tmpdir {
	var parts = me.characters.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
	parts[parts.endIndex - 1] = "prepare"
	let command = parts.joined(separator: "/")

	guard system("\(command) >/dev/null 2>/dev/null") == 0 else {
		fatalError("Failed to execute \(command)")
	}
}
