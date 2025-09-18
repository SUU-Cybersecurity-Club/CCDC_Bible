function Header(h)
  if h.level == 2 then
    return { pandoc.RawBlock('latex', '\\clearpage'), h }
  end
end
