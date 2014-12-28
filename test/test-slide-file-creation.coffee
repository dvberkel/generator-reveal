'use strict'

path = require 'path'
fs = require 'fs'
yeoman = require 'yeoman-generator'

assert = yeoman.assert
helpers = yeoman.test

init_list_dot_json_file = (generator) ->
    fs.mkdirSync generator.destinationPath('slides')
    fs.writeFileSync generator.destinationPath('slides/list.json'), '["index.md"]'

describe 'Sub-Generator Slide', ->
    describe 'default (no options passed)', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments(['Some Default Name'])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates html slide', ->
            assert.fileContent 'slides/some-default-name.html',
                /<h2>Some Default Name<\/h2>/
            assert.fileContent 'slides/list.json',
                /"some-default-name.html"/

    describe 'with --attributes option', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments(['HTML Attributes', '--attributes'])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates html slide with attributes hash in list.json', ->
            assert.fileContent 'slides/html-attributes.html',
                /<h2>HTML Attributes<\/h2>/
            assert.fileContent 'slides/list.json',
                /"filename": "html-attributes.html",/
            assert.fileContent 'slides/list.json',
                /"attr": {/
            assert.fileContent 'slides/list.json',
                /"data-background": "#ff0000"/

    describe 'with --notes option', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments(['HTML With Notes', '--notes'])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates html slide with notes', ->
            assert.fileContent 'slides/html-with-notes.html',
                /<aside class="notes">/
            assert.fileContent 'slides/list.json',
                /"html-with-notes.html"/


    describe 'with --markdown and --notes options', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments([
                    'Markdown With Notes',
                    '--notes',
                    '--markdown'
                ])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates markdown slide with notes', ->
            assert.fileContent 'slides/markdown-with-notes.md',
                /note:/
            assert.fileContent 'slides/list.json',
                /"markdown-with-notes.md"/

    describe 'with --markdown option', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments(['Markdown Format', '--markdown'])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates markdown slide', ->
            assert.fileContent 'slides/markdown-format.md',
                /##  Markdown Format/
            assert.fileContent 'slides/list.json',
                /"markdown-format.md"/

    describe 'with --markdown and --attributes options', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments([
                    'Markdown With Attributes',
                    '--markdown',
                    '--attributes'
                ])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates markdown slide with attributes hash in list.json', ->
            assert.fileContent 'slides/markdown-with-attributes.md',
                /##  Markdown With Attributes/
            assert.fileContent 'slides/list.json',
                /"filename": "markdown-with-attributes.md",/
            assert.fileContent 'slides/list.json',
                /"attr": {/
            assert.fileContent 'slides/list.json',
                /"data-background": "#ff0000"/

    describe 'with --markdown and --directory option', ->
        before (done) ->
            helpers
                .run(path.join __dirname, '../slide')
                .withArguments([
                    'Markdown in Directory',
                    '--markdown',
                    '--directory foo'
                ])
                .on('ready', init_list_dot_json_file)
                .on 'end', done

        it 'creates markdown slide in the slides/foo directory', ->
            assert.file 'slides/foo'
            assert.fileContent 'slides/foo/markdown-in-directory.md',
                /##  Markdown in Directory/
            assert fileContent 'slides/list.json',
                /foo\/markdown-in-directory.md/
