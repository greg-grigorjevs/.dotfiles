--- @type table<string, Snippet>
return {
  ["Public Function"] = {
    prefix = 'fu',
    body = {
      'public function ${1:name}($2): ${3:void}',
      '{',
      '\t${0}',
      '}'
    }
  },
  ["Private Function"] = {
    prefix = 'fup',
    body = {
      'private function ${1:name}($2): ${3:void}',
      '{',
      '\t${0}',
      '}'
    }
  },
  ["If Block"] = {
    prefix = 'if',
    body = {
      'if (\\$$1) {',
      '\t$0',
      '}'
    }
  },
  ["dd"] = {
    prefix = 'dd',
    body = {
      'dd(\\$$0);',
    }
  },
  ["Try Catch Block"] = {
    prefix = 'try',
    body = {
      'try {$0',
      '} catch (\\Throwable \\$e) {',
      '}'
    }
  },
  ["Foreach Block"] = {
    prefix = 'fore',
    body = {
      'foreach (\\$$1 as \\$$2) {',
      '\t$0',
      '}'
    }
  },
  ["New Test"] = {
    prefix = 'test',
    body = {
      'public function test_$1()',
      '{',
      '\t$0',
      '}'
    }
  },
  ["Variable Typehint"] = {
    prefix = 'var',
    body = {
      '/** @var $0 */'
    }
  }
}
