package main

import (
	"bytes"
	"text/template"
)

func main() {

	tpl := template.New("main")
	// provide a func in the FuncMap which can access tpl to be able to look up templates
	tpl.Funcs(map[string]interface{}{
		"CallTemplate": func(name string, data interface{}) (ret string, err error) {
			buf := bytes.NewBuffer([]byte{})
			err = tpl.ExecuteTemplate(buf, name, data)
			ret = buf.String()
			return
		},
	})
}
