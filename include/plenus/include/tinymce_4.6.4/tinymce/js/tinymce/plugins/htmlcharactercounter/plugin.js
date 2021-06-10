/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


tinymce.PluginManager.add('htmlcharactercounter', function (editor) {
    var self = this;

    function update() {
        editor.theme.panel.find('#htmlcharactercounter').text(['Data Remaining: {0} MB', (3e+6 - (self.getCount() * 3)) / 1e+6]);
    }

    editor.on('init', function () {
        var statusbar = editor.theme.panel && editor.theme.panel.find('#statusbar')[0];

        if (statusbar) {
            window.setTimeout(function () {
                statusbar.insert({
                    type: 'label',
                    name: 'htmlcharactercounter',
                    text: ['Data Remaining: {0} MB', (3e+6 - (self.getCount() * 3)) / 1e+6], //each character needs 3 bytes to store into UTF-8 database
                    classes: 'htmlcharactercounter',
                    disabled: editor.settings.readonly
                }, 0);

                editor.on('setcontent beforeaddundo', update);

                editor.on('keyup', function (e) {
                    update();
                });
            }, 0);
        }
    });

    self.getCount = function () {
        var tx = editor.getContent({format: 'raw'});
        var tc = tx.length;
        return tc;
    };
});