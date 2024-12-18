return {
  settings = {
    yaml = {
      schemas = {
        ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = '*-cfn.{yml,yaml}',
      },
      -- for cloudformation tags
      customTags = {
        '!Cidr',
        '!Cidr sequence',
        '!And',
        '!And sequence',
        '!If',
        '!If sequence',
        '!Not',
        '!Not sequence',
        '!Equals',
        '!Equals sequence',
        '!Or',
        '!Or sequence',
        '!FindInMap',
        '!FindInMap sequence',
        '!Base64',
        '!Join',
        '!Join sequence',
        '!Ref',
        '!Sub',
        '!Sub sequence',
        '!GetAtt',
        '!GetAZs',
        '!ImportValue',
        '!ImportValue sequence',
        '!Select',
        '!Select sequence',
        '!Split',
        '!Split sequence',
      },
    },
  },
}
