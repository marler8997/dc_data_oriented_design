# Compiler Design

Though I haven't done any data oriented design, I'd like to see how a compiler would look using it.  The following shows how I think the data would look during compilation:

```
ModuleSource (source code read from module file, null terminated)

ModuleSource -> ParsedModule (lexer/parser)

// flat array of declarations
struct ParsedModule
{
    static struct Decl
    {
        Identifier id;
        uint size;
        DeclKind kind;
        union
        {
            // data
        }
    }
    size_t[Identifier] nameMap; // a map from symbol name to node offset
    Decl nodes; // Decl has an offset to the next decl?
    ...
}

ParsedModule -> ?
```