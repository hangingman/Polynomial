# coding: utf-8

module PolyWork # Work routines for polynomial
  def cnv_prog_format(str)
    # convert from "tex", "texm" or "text" format to "prog" format
    # c.f. Polynomial("str")
    s = str.clone
    s = s.gsub(/ \t/, "") # has no-space
    s = s.gsub(/\^/, "**") # power be **
    #vanish TeX symbol $, and {,} convert to (,).
    s = s.gsub(/\$/, "").gsub(/[{]/, "(").gsub(/[}]/, ")")
    # insert "*" between coefficient and variable
    s = " " + s
    s = s.gsub(/[^a-zA-Z_0-9][0-9]+[a-z]/) { |m| m.gsub(/[a-z$]/) { |v| "*" + v } }
    # insert "*" near brackets (  )
    s = s.gsub(/[a-zA-Z0-9\)][ \t]*\(/) { |m| m[1] = "*"; m + "(" } # A( --> A*(
    s = s.gsub(/\)[ \t]*[a-zA-Z0-9\(]/) { |m| m[0] = "*"; ")" + m } # )B --> )*B
    return s
  end

  module_function :cnv_prog_format
end # PolyWorks
