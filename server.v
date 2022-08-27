
module main

// importing tw2
import vweb
import net.websocket
import rand
import os
import freeflowuniverse.crystallib.twinclient2 as tw2

const (
	port = 8000
)

struct App {
	vweb.Context
mut:
	state shared State
}

struct State {
mut:
	cnt int
}

fn start_client() ?&websocket.Client {
	mut ws := websocket.new_client('ws://localhost:8081')?
	ws.connect() or { println('error on connect: $err') }
	return ws
}

fn main() {
	mut app := &App{}
	app.serve_static('/htmx.min.js', 'htmx.min.js')
	app.serve_static('/static/css/index.css', 'static/css/index.css')
	app.serve_static('/echotest.html', 'echotest.html')
	vweb.run(app, port)
}

pub fn (mut app App) test() vweb.Result {
	content := os.read_file('templates/with_input.html') or { panic(error) }
	return app.html(content)
}

pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) click_me() vweb.Result {
	println('running')
	// mut ws_client := start_client() or { return app.text('Error creating websocket client') }
	// mut tw2_client := tw2.init_client(mut ws_client) // repeated calls to init_client will return the same twin client if the ws_client is the same.
	// mut twin := tw2_client.get_twin(414) or { return app.text('errr2') }
	return app.text('I am not longer an button')
}

pub fn (mut app App) get_echo() vweb.Result {
	content := os.read_file('templates/with_input.html') or { panic(error) }
	return app.html(content)
}

[post]
pub fn (mut app App) echo() vweb.Result {
	return app.text('Hello world from vweb')
}

pub fn hello_world(hello string, world string) string {
	return hello + ' ' + world
}

pub fn (mut app App) hello_world() vweb.Result {
	hello := 'hello'
	world := 'world'
	return app.text(hello_world(hello, world))
}

pub fn (mut app App) load_dashboard() vweb.Result {
	content := os.read_file('templates/dark_sidebar_with_light_header.html') or { panic(error) }
	return app.html(content)
}

/*
pub fn wsEcho(c echo.Context) ? {

	handler := websocket.Handler(func(ws *websocket.Conn) {

		defer ws.Close()

		for {

			msg := ""

			if err := websocket.Message.Receive(ws, &msg); err != nil {
				c.Logger().Error("receive", err)
				return
			}

			response := `<div id="idMessage" hx-swap-oob="true">` + msg + `</div>`

			if err := websocket.Message.Send(ws, response); err != nil {
				c.Logger().Error("send", err)
				return
			}
		}
	})

	handler.ServeHTTP(c.Response(), c.Request())
	return nil
}
*/
