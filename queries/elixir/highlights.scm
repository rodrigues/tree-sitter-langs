; Reserved keywords

["when" "and" "or" "not" "in" "fn" "do" "end" "catch" "rescue" "after" "else"] @keyword

; Operators

; * doc string
(unary_operator
  operator: "@" @attribute
  operand: (call
    target: (identifier) @doc.__attribute__
    (arguments
      [
        (string) @doc
        (charlist) @doc
        (sigil
          quoted_start: _ @doc
          quoted_end: _ @doc) @doc
        (boolean) @doc
      ]))
  (#match? @doc.__attribute__ "^(moduledoc|typedoc|doc)$"))

; * module attribute
(unary_operator
  operator: "@" @attribute
  operand: [
    (identifier) @attribute
    (call
      target: (identifier) @attribute)
    (boolean) @attribute
    (nil) @attribute
  ])

; * capture operand
(unary_operator
  operator: "&"
  operand: (integer) @operator)

(operator_identifier) @operator

(unary_operator
  operator: _ @operator)

(binary_operator
  operator: "::" @punctuation.delimiter)

(binary_operator
  operator: _ @operator)

(dot
  operator: _ @punctuation.delimiter)

(stab_clause
  operator: _ @operator)

; Literals

[
  (boolean)
  (nil)
] @constant

[
  (integer)
  (float)
] @number

(alias) @type

(call
  target: (dot
    left: (alias) @type))

(char) @constant

; Quoted content

(interpolation "#{" @punctuation.special "}" @punctuation.special) @embedded

(escape_sequence) @escape

[
  (atom)
  (quoted_atom)
  (keyword)
  (quoted_keyword)
] @constant

[
  (string)
  (charlist)
] @string

; Note that we explicitly target sigil quoted start/end, so they are not overridden by delimiters

(sigil
  (sigil_name) @__name__
  quoted_start: _ @string
  quoted_end: _ @string
  (#match? @__name__ "^[sS]$")) @string

(sigil
  (sigil_name) @__name__
  quoted_start: _ @string.special
  quoted_end: _ @string.special
  (#match? @__name__ "^[rR]$")) @string.special

(sigil
  (sigil_name) @__name__
  quoted_start: _ @string.special
  quoted_end: _ @string.special) @string.special

; Calls

; * definition keyword
(call
  target: (identifier) @keyword
  (#match? @keyword "^(def|defdelegate|defexception|defguard|defguardp|defimpl|defmacro|defmacrop|defmodule|defn|defnp|defoverridable|defp|defprotocol|defstruct)$"))

; * kernel or special forms keyword
(call
  target: (identifier) @keyword
  (#match? @keyword "^(alias|case|cond|else|for|if|import|quote|raise|receive|require|reraise|super|throw|try|unless|unquote|unquote_splicing|use|with)$"))


; * function definition
(call
  target: (identifier) @keyword
  (arguments [
    (identifier) @function
    (call
      target: (identifier) @function)
    (binary_operator
      left: (call
              target: (identifier) @function)
      operator: "when")
  ])
  (#match? @keyword "^(def|defdelegate|defn|defnp|defp)$"))

; * macro function definition
(call
  target: (identifier) @keyword
  (arguments [
    (identifier) @function.macro
    (call
      target: (identifier) @function.macro)
    (binary_operator
      left: (call
              target: (identifier) @function.macro)
      operator: "when")
   ])
  (#match? @keyword "^(defguard|defguardp|defmacro|defmacrop)$"))

; * variable parameter definition in def*
(call
  target: (identifier) @keyword
  (arguments [
    (call
      target: (identifier)
      (arguments ((_)* @variable.parameter)))
    (binary_operator
      left: (call
              target: (identifier)
              (arguments ((_)* @variable.parameter)))
      operator: "when")
   ])
  (#match? @keyword "^(def|defdelegate|defn|defnp|defp|defguard|defguardp|defmacro|defmacrop)$"))

; variable binding
(binary_operator
 left: (identifier) @variable
 operator: "=")

; * function call
(call
  target: [
    ; local
    (identifier) @function.builtin
    ; remote
    (dot
      right: (identifier) @function.call)
  ]
  (arguments (_)*))
;; ; * pipe into identifier (function call)
;; (binary_operator
;;   operator: "|>"
;;   right: (identifier) @function.call)

;; ; * pipe into identifier (definition)
;; (call
;;   target: (identifier) @keyword
;;   (arguments
;;     (binary_operator
;;       operator: "|>"
;;       right: (identifier) @variable))
;;   (#match? @keyword "^(def|defdelegate|defguard|defguardp|defmacro|defmacrop|defn|defnp|defp)$"))

; Identifiers

; * special
(
  (identifier) @constant.builtin
  (#match? @constant.builtin "^(__MODULE__|__DIR__|__ENV__|__CALLER__|__STACKTRACE__)$")
)

; * unused
(
  (identifier) @noise
  (#match? @noise "^_")
)

; * regular
;; not for usage, @variable should be for declaration (a = something, %{x: a} = something), and param
;;(identifier) @variable

; Comment

(comment) @comment

; Punctuation

[
 "%"
] @punctuation

[
 ","
 ";"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "<<"
  ">>"
] @punctuation.bracket
