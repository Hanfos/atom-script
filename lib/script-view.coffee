{ScrollView, BufferedProcess} = require 'atom'

# Runs a portion of a script through an interpreter and displays it line by line

module.exports =
class ScriptView extends ScrollView

  @content: ->
    @div class: 'script', tabindex: -1, =>
      @div class: 'output'

  constructor: (interpreter, make_args) ->
    super
    @interpreter = interpreter
    @make_args = make_args

  # TODO: Add language to title
  getTitle: -> "Script"

  addLine: (line, out_type) ->
    console.log(line)
    @find("div.output").append("<pre class='line #{out_type}'>#{line}</pre>")

  runit: (code) ->
    command = @interpreter

    args = @make_args(code)

    # Default to where the user opened atom
    options =
      cwd: atom.project.getPath()

    console.log("Running " + command + " " + args)

    stdout = (output) => @addLine(output, "stdout")
    stderr = (output) => @addLine(output, "stderr")
    exit = (return_code) -> console.log("Exited with #{return_code}")

    process = new BufferedProcess({command, args, options, stdout, stderr, exit})
