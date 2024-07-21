
when not defined(nimscript): import system/nimscript

when defined(nimPreviewSlimSystem):
  import std/[
    syncio, assertions, formatfloat, objectdollar, widestrs
  ]

from std/algorithm import sorted
from std/sequtils import filterIt
from std/strutils import startsWith, endsWith, `%`, split, replace, count
from std/os import commandLineParams, `/`, splitPath, getCurrentCompilerExe

#
# common tasks
#
when not defined(nimsuggest):
  template collectFiles(rootDirs: openArray[string], pred: untyped): seq[string] =
    var
      dirs = @rootDirs
      result: seq[string]
    while dirs.len > 0:
      let d = dirs.pop
      dirs &= d
        .listDirs
        .filterIt(not (it.endsWith(".git") or it.endsWith("bin")))
      for it {.inject.} in d.listFiles:
        if pred: result.add it
    result

  task checkAll, "check all source codes with `nim check`":
    var failed = 0
    let srcDir =
      if dirExists("src"): "src"
      else: ""
    let files = collectFiles(["tests", srcDir], it.endsWith(".nim"))
    const hintBuildMode =
      when defined(nimHasHintBuildMode): "--hint:BuildMode:off"
      else: ""
    for f in files:
      echo "Checking $#" % f
      try:
        exec(getCurrentCompilerExe() & " check " & hintBuildMode & " --hint:SuccessX:off $#" % f)
      except:
        inc failed
      echo ""
    echo "failed $# checks" % $failed
    doAssert failed == 0

  task testAll, "run all tests recursively":
    let files = collectFiles(["tests"], it.startsWith("t") and it.endsWith(".nim"))
    for f in files:
      let cmd = "nim c --run $#" % f
      echo "Running `$#`" % cmd
      exec(cmd)

  task cleanCache, "clean the global nimcache directory":
    let cacheDir =
      when defined(windows):
        os.getCacheDir()
      else:
        getEnv("XDG_CACHE_DIR", getEnv("HOME") / ".cache")
    let nimcache = cacheDir / "nim"
    if nimcache.dirExists:
      echo "cleaning ", nimcache
      rmDir nimcache
      mkDir nimcache
      echo "done"
    else:
      echo nimcache, " didn't exist"

  task argEcho, "Just echo back the arguments":
    echo commandLineParams()
    setCommand "nop"
    # XXX: hacky way to ensure nothing else happens after this.
    #      This prevents the compiler from reading the script from stdin and
    #      executing it as Nimscript when the command line is `nim argEcho -`.
    hint("QuitCalled", off)
    quit 0

#
# config
#

when (NimMajor, NimMinor) >= (1, 5):
  switch("filenames", "canonical")
  # switch("experimental", "strictEffects")
  switch("experimental", "unicodeOperators")
  switch("experimental", "overloadableEnums")
  switch("define", "nimPreviewDotLikeOps")
  switch("define", "nimPreviewFloatRoundtrip")
  switch("define", "nimStrictDelete")

when not defined(nimsuggest):
  hint("Conf", off)
  hint("Source", on)
  when defined(nimHasHintBuildMode):
    when getCommand() == "check":
      hint("BuildMode", off)

  when defined(macosx):
    block:
      let clangLtoLinker =
        get("clang.options.linker").replace("-fuse-ld=lld")
      let clangCppLtoLinker =
        get("clang.cpp.options.linker").replace("-fuse-ld=lld")
      put("clang.options.linker", clangLtoLinker)
      put("clang.cpp.options.linker", clangCppLtoLinker)

    block:
      const gccDir = "/usr/local/opt/gcc"
      let files = block:
        var a: seq[string]
        for it in listfiles(gccdir / "bin"):
          let tail = it.splitPath.tail
          if tail.count('-') == 1 and tail.split('-')[0] in ["gcc", "g++"]:
            a.add it
        a.sorted

      # files should be @["/usr/local/opt/gcc/bin/g++-XX", "/usr/local/opt/gcc/bin/gcc-XX"]
      if files.len > 0:
        put("gcc.cpp.exe", files[0])
        put("gcc.cpp.linkerexe", files[0])
        put("gcc.exe", files[1])
        put("gcc.linkerexe", files[1])

# XXX -fwhole-program for gcc-10

