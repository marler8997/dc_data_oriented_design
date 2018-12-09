import std.array : Appender;

import dc.file : ReadFile;

struct Global
{
    static __gshared Object lock = new Object();
    static __gshared Appender!(ParsedModule[]) parsedModules;
}

struct ParsedModule
{
}

ParsedModule* parseModule(ReadFile readFile)
{
    import dmd.parse;
    import dmd.dmodule;
    import dmd.astcodegen;
    import dmd.identifier;

    auto idString = "placeholder_module_id";
    auto id = Identifier.idPool(idString);
    auto mod = new Module(readFile.normalizedName.val.ptr, id, 0, 0);
    scope parser = new Parser!ASTCodegen(mod, readFile.text.val, false);
    parser.nextToken();
    auto parsed = parser.parseModule();

    return null;
}