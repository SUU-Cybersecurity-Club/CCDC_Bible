-- Keep sections by class and/or id, including all descendants.
-- Supports tokens:
--   ".class"         → keep any header that has this class
--   "#id"            → keep the header with this id
--   ".class#id"      → keep the header whose id AND class both match
--
-- You can pass tokens via metadata (-M) as a string or list:
--   -M keep='.os,#debian10,.os#fedora'
--   -M keep='[".os",".os#debian10",".os#fedora"]'
--
-- Convenience (optional): separate lists
--   -M keep-classes='["os","ops"]'
--   -M keep-ids='["debian10","fedora"]'
--
-- Optional:
--   -M keep-preface=true   → also keep content before the first kept header

local stringify = pandoc.utils.stringify

-- Sets of what to keep
local KEEP_CLASSES = {}            -- class → true
local KEEP_IDS     = {}            -- id → true
local KEEP_PAIRS   = {}            -- class → { id → true }
local HAVE_FILTER  = false
local KEEP_PREFACE = false

-- ---- helpers --------------------------------------------------------------

local function trim(s) return (s:gsub("^%s+",""):gsub("%s+$","")) end

local function add_class(c)
  if c and c ~= "" then KEEP_CLASSES[c:lower()] = true; HAVE_FILTER = true end
end

local function add_id(i)
  if i and i ~= "" then KEEP_IDS[i:lower()] = true; HAVE_FILTER = true end
end

local function add_pair(c, i)
  if not c or c == "" or not i or i == "" then return end
  c, i = c:lower(), i:lower()
  KEEP_PAIRS[c] = KEEP_PAIRS[c] or {}
  KEEP_PAIRS[c][i] = true
  HAVE_FILTER = true
end

-- Parse a single keep token like ".os", "#debian10", ".os#debian10"
local function parse_token(tok)
  tok = trim(tok)
  if tok == "" then return end
  if tok:sub(1,1) == "." then
    local rest = tok:sub(2)
    local cls, id = rest:match("^([^#]+)#(.+)$")
    if cls and id then add_pair(cls, id)
    else add_class(rest) end
  elseif tok:sub(1,1) == "#" then
    add_id(tok:sub(2))
  else
    -- bareword: treat as class for convenience
    add_class(tok)
  end
end

-- Split comma/whitespace separated string into tokens
local function split_tokens(s)
  local out = {}
  for tok in tostring(s):gmatch("[^,%s]+") do table.insert(out, tok) end
  return out
end

-- Determine if header matches any keep rule
local function header_matches(h)
  local id = (h.identifier or ""):lower()
  if id ~= "" and KEEP_IDS[id] then return true end

  -- class blanket or class+id pair
  if h.classes then
    for _, c in ipairs(h.classes) do
      local lc = c:lower()
      if KEEP_CLASSES[lc] then return true end
      local pairs = KEEP_PAIRS[lc]
      if pairs and id ~= "" and pairs[id] then return true end
    end
  end

  return false
end

-- ---- metadata -------------------------------------------------------------

function Meta(m)
  -- keep: string or list
  local k = m.keep
  if k ~= nil then
    if k.t == "MetaList" then
      for _, item in ipairs(k) do parse_token(stringify(item)) end
    else
      for _, tok in ipairs(split_tokens(stringify(k))) do parse_token(tok) end
    end
  end

  -- optional separate lists
  local kc = m["keep-classes"]
  if kc then
    if kc.t == "MetaList" then
      for _, item in ipairs(kc) do add_class(stringify(item)) end
    else
      for _, tok in ipairs(split_tokens(stringify(kc))) do add_class(tok) end
    end
  end
  local ki = m["keep-ids"]
  if ki then
    if ki.t == "MetaList" then
      for _, item in ipairs(ki) do add_id(stringify(item)) end
    else
      for _, tok in ipairs(split_tokens(stringify(ki))) do add_id(tok) end
    end
  end

  -- keep-preface: true/false
  local kp = m["keep-preface"]
  if kp ~= nil then
    local s = stringify(kp):lower()
    KEEP_PREFACE = (s == "true" or s == "yes" or s == "1")
  end
end

-- ---- main ---------------------------------------------------------------

function Pandoc(doc)
  if not HAVE_FILTER then
    -- No filters specified → keep entire document unchanged.
    return doc
  end

  local kept = pandoc.Blocks({})
  local include = KEEP_PREFACE          -- content before first kept header?
  local keep_stack = {}                 -- level → true if ancestor matched

  local function any_kept_ancestor(level)
    for i = 1, level - 1 do
      if keep_stack[i] then return true end
    end
    return false
  end

  for _, blk in ipairs(doc.blocks) do
    if blk.t == "Header" then
      local L = blk.level
      -- drop deeper levels from the stack when we move up
      for i = L + 1, 6 do keep_stack[i] = nil end

      local match = header_matches(blk)
      keep_stack[L] = match or false
      include = match or any_kept_ancestor(L)

      if include then kept:insert(blk) end
    else
      if include then kept:insert(blk) end
    end
  end

  return pandoc.Pandoc(kept, doc.meta)
end