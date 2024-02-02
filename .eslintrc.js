module.exports = {
  'env': {
    'browser': true,
    'es6': true,
    'node': true
  },
  'extends': [
    'eslint:recommended',
    'plugin:vue/essential'
  ],
  'parserOptions': {
    'sourceType': 'module'
  },
  'rules': {
    'indent': [
      'error',
      2
    ],
    'linebreak-style': [
      'error',
      'unix'
    ],
    'quotes': [
      'warn',
      'single'
    ],
    'semi': [
      'error',
      'always'
    ],
    'eqeqeq': [
      'warn',
      'always'
    ],
    'brace-style': [
      'warn',
      'stroustrup'
    ],
    'no-console': 0,
    'no-var': 'warn',
    'max-len': [
      'error',
      80
    ]
  },
  'globals': {
    'require': true
  }
};
