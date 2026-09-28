--- @type table<string, Snippet>
return {
  ["New Snippet"] = {
    prefix = 'news',
    body = {
      '["$1"] = {',
      " prefix = '$2',",
      ' body = {',
      "   '$0',",
      ' }',
      '},'
    }
  },
}
