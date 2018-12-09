module dc.sentinel;

private struct CStringTemplate(T)
{
    private T* ptr;
    @disable this();
    private this(T* ptr) { this.ptr = ptr; }
    auto val() const { return cast(T*)ptr; }
}

alias cstr = CStringTemplate!(const(char));
alias mutable_cstr = CStringTemplate!char;
alias immutable_cstr = CStringTemplate!(immutable(char));

auto assumeSentinel(T)(T* ptr) { return CStringTemplate!T(ptr); }


private struct CStringArrayTemplate(T)
{
    private T[] array;
    //@disable this();
    private this(T[] array) { this.array = array; }
    auto val() const { return cast(T[])array; }
    auto asCstr() const { return (cast(T[])array).ptr.assumeSentinel; }

    //static if ( !is ( T[] == immutable(T)[]) )
    //{
    auto asImmutable() const
    {
        import dc.util : asImmutable;
        return CStringArrayTemplate!(immutable(T))(array.asImmutable);
    }
    //}
}
alias const_zstring = CStringArrayTemplate!(const(char));
alias mutable_zstring = CStringArrayTemplate!char;
alias zstring = CStringArrayTemplate!(immutable(char));

auto assumeSentinel(T)(T[] s) { return CStringArrayTemplate!T(s); }
CStringArrayTemplate!char makeSentinel(T)(T[] s)
{
    auto sentinelString = new char[s.length + 1];
    sentinelString[0 .. s.length] = s[];
    sentinelString[s.length] = '\0';
    return sentinelString[0 .. s.length].assumeSentinel;
}
