function Header(h)
  if h.level == 1 then
    return { pandoc.RawBlock('latex', '\\clearpage'), h }
  end
end
