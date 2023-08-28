Test code snippets from the markdown files

  $ cat > dune-project <<EOF
  > (lang dune 3.8)
  > (using melange 0.1)
  > EOF
  $ cat > dune <<EOF
  > (melange.emit
  >  (emit_stdlib false)
  >  (target output)
  >  (preprocess (pps melange.ppx)))
  > EOF

  $ cat > input.ml <<\EOF
  > let default = 10
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let print name = "Hello" ^ name
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type person = private {
  >   name : string;
  >   age : int;
  > }
  > [@@bs.deriving abstract]
  > EOF

  $ dune build @melange
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving abstract]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > type person = {
  >   name : string;
  >   mutable age : int;
  > }
  > [@@bs.deriving abstract]
  > 
  > let alice = person ~name:"Alice" ~age:20
  > 
  > let () = ageSet alice 21
  > EOF

  $ dune build @melange
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving abstract]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 7, characters 12-18:
  7 | let alice = person ~name:"Alice" ~age:20
                  ^^^^^^
  Error: Unbound value person
  [1]

  $ cat > input.ml <<\EOF
  > type person = {
  >   name : string;
  >   age : int;
  > }
  > [@@bs.deriving { abstract = light }]
  > 
  > let alice = person ~name:"Alice" ~age:20
  > let aliceName = name alice
  > EOF

  $ dune build @melange
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving { abstract = light }]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 7, characters 12-18:
  7 | let alice = person ~name:"Alice" ~age:20
                  ^^^^^^
  Error: Unbound value person
  [1]

  $ cat > input.ml <<\EOF
  > let twenty = ageGet alice
  > 
  > let bob = nameGet bob
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 13-19:
  1 | let twenty = ageGet alice
                   ^^^^^^
  Error: Unbound value ageGet
  [1]

  $ cat > input.ml <<\EOF
  > let alice = person ~name:"Alice" ~age:20 ()
  > let bob = person ~name:"Bob" ()
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 12-18:
  1 | let alice = person ~name:"Alice" ~age:20 ()
                  ^^^^^^
  Error: Unbound value person
  [1]

  $ cat > input.ml <<\EOF
  > type person
  > 
  > val person : name:string -> ?age:int -> unit -> person
  > 
  > val nameGet : person -> string
  > 
  > val ageGet : person -> int option
  > EOF

  $ dune build @melange
  File "input.ml", line 3, characters 0-54:
  3 | val person : name:string -> ?age:int -> unit -> person
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: Value declarations are only allowed in signatures
  [1]

  $ cat > input.ml <<\EOF
  > type person = {
  >   name : string;
  >   age : int; [@bs.optional]
  > }
  > [@@bs.deriving abstract]
  > EOF

  $ dune build @melange
  File "input.ml", line 3, characters 15-26:
  3 |   age : int; [@bs.optional]
                     ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.optional]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving abstract]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > type person = {
  >   name : string;
  >   age : int option;
  > }
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let name (param : pet) = param.name
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 18-21:
  1 | let name (param : pet) = param.name
                        ^^^
  Error: Unbound type constructor pet
  [1]

  $ cat > input.ml <<\EOF
  > type pet = { name : string } [@@bs.deriving accessors]
  > 
  > let pets = [| { name = "Brutus" }; { name = "Mochi" } |]
  > 
  > let () = pets |. Belt.Array.map name |. Js.Array2.joinWith "&" |. Js.log
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 32-43:
  1 | type pet = { name : string } [@@bs.deriving accessors]
                                      ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 5, characters 32-36:
  5 | let () = pets |. Belt.Array.map name |. Js.Array2.joinWith "&" |. Js.log
                                      ^^^^
  Error: Unbound value name
  [1]

  $ cat > input.ml <<\EOF
  > val actionToJs : action -> string
  > 
  > val actionFromJs : string -> action option
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 17-23:
  1 | val actionToJs : action -> string
                       ^^^^^^
  Error: Unbound type constructor action
  Hint: Did you mean option?
  [1]

  $ cat > input.ml <<\EOF
  > type action =
  >   [ `Click
  >   | `Submit [@bs.as "submit"]
  >   | `Cancel
  >   ]
  > [@@bs.deriving jsConverter]
  > EOF

  $ dune build @melange
  File "input.ml", line 3, characters 14-19:
  3 |   | `Submit [@bs.as "submit"]
                    ^^^^^
  Alert unused: Unused attribute [@bs.as]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 6, characters 3-14:
  6 | [@@bs.deriving jsConverter]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > val actionToJs : action -> abs_action
  > 
  > val actionFromJs : abs_action -> action
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 17-23:
  1 | val actionToJs : action -> abs_action
                       ^^^^^^
  Error: Unbound type constructor action
  Hint: Did you mean option?
  [1]

  $ cat > input.ml <<\EOF
  > type action =
  >   | Click
  >   | Submit [@bs.as 3]
  >   | Cancel
  > [@@bs.deriving { jsConverter = newType }]
  > EOF

  $ dune build @melange
  File "input.ml", line 3, characters 13-18:
  3 |   | Submit [@bs.as 3]
                   ^^^^^
  Alert unused: Unused attribute [@bs.as]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving { jsConverter = newType }]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > val actionToJs : action -> int
  > 
  > val actionFromJs : int -> action option
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 17-23:
  1 | val actionToJs : action -> int
                       ^^^^^^
  Error: Unbound type constructor action
  Hint: Did you mean option?
  [1]

  $ cat > input.ml <<\EOF
  > type action =
  >   | Click
  >   | Submit [@bs.as 3]
  >   | Cancel
  > [@@bs.deriving jsConverter]
  > EOF

  $ dune build @melange
  File "input.ml", line 3, characters 13-18:
  3 |   | Submit [@bs.as 3]
                   ^^^^^
  Alert unused: Unused attribute [@bs.as]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving jsConverter]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > type action =
  >   | Click
  >   | Submit of string
  >   | Cancel
  > 
  > let click = (Click : action)
  > let submit param = (Submit param : action)
  > let cancel = (Cancel : action)
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type action =
  >   | Click
  >   | Submit of string
  >   | Cancel
  > [@@bs.deriving accessors]
  > EOF

  $ dune build @melange
  File "input.ml", line 5, characters 3-14:
  5 | [@@bs.deriving accessors]
         ^^^^^^^^^^^
  Alert unused: Unused attribute [@bs.deriving]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > type element
  > type document
  > external get_by_id : document -> string -> element option = "getElementById"
  >   [@@bs.send] [@@bs.return nullable]
  > 
  > let test document =
  >   let elem = get_by_id document "header" in
  >   match elem with
  >   | None -> 1
  >   | Some _element -> 2
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type x
  > external x : x = "x" [@@bs.val]
  > external set_onload : x -> ((x -> int -> unit)[@bs.this]) -> unit = "onload"
  >   [@@bs.set]
  > external resp : x -> int = "response" [@@bs.get]
  > let _ =
  >   set_onload x
  >     begin
  >       fun [@bs.this] o v -> Js.log (resp o + v)
  >     end
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let add x y = x + y
  > let _ = map [||] [||] add
  > EOF

  $ dune build @melange
  File "input.ml", line 2, characters 8-11:
  2 | let _ = map [||] [||] add
              ^^^
  Error: Unbound value map
  Hint: Did you mean max?
  [1]

  $ cat > input.ml <<\EOF
  > external map :
  >   'a array -> 'b array -> (('a -> 'b -> 'c)[@bs.uncurry]) -> 'c array = "map"
  >   [@@bs.val]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let add = fun [@bs] x y -> x + y
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let add x y = x + y
  > let _ = map [||] [||] add
  > EOF

  $ dune build @melange
  File "input.ml", line 2, characters 8-11:
  2 | let _ = map [||] [||] add
              ^^^
  Error: Unbound value map
  Hint: Did you mean max?
  [1]

  $ cat > input.ml <<\EOF
  > external map : 'a array -> 'b array -> (('a -> 'b -> 'c)[@bs]) -> 'c array
  >   = "map"
  >   [@@bs.val]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let add x = let partial y = x + y in partial
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external map : 'a array -> 'b array -> ('a -> 'b -> 'c) -> 'c array = "map"
  >   [@@bs.val]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let add x y = x + y
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external process_on_exit : (_[@bs.as "exit"]) -> (int -> unit) -> unit
  >   = "process.on"
  >   [@@bs.val]
  > 
  > let () =
  >   process_on_exit (fun exit_code ->
  >     Js.log ("error code: " ^ string_of_int exit_code))
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type readline
  > 
  > external on :
  >   readline ->
  >   ([ `close of unit -> unit | `line of string -> unit ][@bs.string]) ->
  >   readline = "on"
  >   [@@bs.send]
  > 
  > let register rl =
  >   rl |. on (`close (fun event -> ())) |. on (`line (fun line -> Js.log line))
  > EOF

  $ dune build @melange
  File "input.ml", line 10, characters 24-29:
  10 |   rl |. on (`close (fun event -> ())) |. on (`line (fun line -> Js.log line))
                               ^^^^^
  Error (warning 27 [unused-var-strict]): unused variable event.
  [1]

  $ cat > input.ml <<\EOF
  > external test_int_type :
  >   ([ `on_closed | `on_open [@bs.as 20] | `in_bin ][@bs.int]) -> int
  >   = "testIntType"
  >   [@@bs.val]
  > 
  > let value = test_int_type `on_open
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type document
  > type style
  > 
  > external document : document = "document" [@@bs.val]
  > external get_by_id : document -> string -> Dom.element = "getElementById"
  >   [@@bs.send]
  > external style : Dom.element -> style = "style" [@@bs.get]
  > external transition_timing_function :
  >   style ->
  >   [ `ease
  >   | `easeIn [@bs.as "ease-in"]
  >   | `easeOut [@bs.as "ease-out"]
  >   | `easeInOut [@bs.as "ease-in-out"]
  >   | `linear
  >   ] ->
  >   unit = "transitionTimingFunction"
  >   [@@bs.set]
  > 
  > let element_style = style (get_by_id document "my-id")
  > let () = transition_timing_function element_style `easeIn
  > EOF

  $ dune build @melange
  File "input.ml", line 11, characters 14-19:
  11 |   | `easeIn [@bs.as "ease-in"]
                     ^^^^^
  Alert unused: Unused attribute [@bs.as]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 12, characters 15-20:
  12 |   | `easeOut [@bs.as "ease-out"]
                      ^^^^^
  Alert unused: Unused attribute [@bs.as]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  
  File "input.ml", line 13, characters 17-22:
  13 |   | `easeInOut [@bs.as "ease-in-out"]
                        ^^^^^
  Alert unused: Unused attribute [@bs.as]
  This means such annotation is not annotated properly.
  For example, some annotations are only meaningful in externals
  

  $ cat > input.ml <<\EOF
  > external read_file_sync :
  >   name:string -> ([ `utf8 | `ascii ][@bs.string]) -> string = "readFileSync"
  >   [@@bs.module "fs"]
  > 
  > let _ = read_file_sync ~name:"xx.txt" `ascii
  > EOF

  $ dune build @melange
  File "input.ml", line 2, characters 18-36:
  2 |   name:string -> ([ `utf8 | `ascii ][@bs.string]) -> string = "readFileSync"
                        ^^^^^^^^^^^^^^^^^^
  Alert redundant: [@bs.string] is redundant here, you can safely remove it

  $ cat > input.ml <<\EOF
  > external padLeft:
  >   string
  >   -> ([ `Str of string
  >       | `Int of int
  >       ] [@bs.unwrap])
  >   -> string
  >   = "padLeft" [@@bs.val]
  > 
  > let _ = padLeft "Hello World" (`Int 4)
  > let _ = padLeft "Hello World" (`Str "Message from Melange: ")
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external drawCat : unit -> unit = "draw" [@@bs.module "MyGame"]
  > external drawDog : giveName:string -> unit = "draw" [@@bs.module "MyGame"]
  > external draw : string -> useRandomAnimal:bool -> unit = "draw"
  >   [@@bs.module "MyGame"]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type hide = Hide : 'a -> hide [@@unboxed]
  > 
  > external join : hide array -> string = "join" [@@bs.module "path"] [@@bs.variadic]
  > 
  > let v = join [| Hide "a"; Hide 2 |]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external join : string array -> string = "join"
  >   [@@bs.module "path"] [@@bs.variadic]
  > let v = join [| "a"; "b" |]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > (* Abstract type for the `document` global *)
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > external get_by_id : string -> Dom.element = "getElementById"
  >   [@@bs.send.pipe: document]
  > external get_by_classname : string -> Dom.element = "getElementsByClassName"
  >   [@@bs.send.pipe: Dom.element]
  > 
  > let el = document |> get_by_id "my-id" |> get_by_classname "my-class"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > (* Abstract type for the `document` global *)
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > external get_by_id : document -> string -> Dom.element = "getElementById"
  >   [@@bs.send]
  > external get_by_classname : Dom.element -> string -> Dom.element
  >   = "getElementsByClassName"
  >   [@@bs.send]
  > 
  > let el = document |. get_by_id "my-id" |. get_by_classname "my-class"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > (* Abstract type for the `document` global *)
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > external get_by_id : string -> Dom.element = "getElementById"
  >   [@@bs.send.pipe: document]
  > 
  > let el = get_by_id "my-id" document
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > (* Abstract type for the `document` global *)
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > external get_by_id : document -> string -> Dom.element = "getElementById"
  >   [@@bs.send]
  > 
  > let el = get_by_id document "my-id"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external draw : x:int -> y:int -> ?border:bool -> unit -> unit = "draw"
  >   [@@module "MyGame"]
  > let () = draw ~x:10 ~y:20 ()
  > let () = draw ~y:20 ~x:10 ()
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external draw : x:int -> y:int -> ?border:bool -> unit -> unit = "draw"
  >   [@@module "MyGame"]
  > 
  > let () = draw ~x:10 ~y:20 ~border:true ()
  > let () = draw ~x:10 ~y:20 ()
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t
  > 
  > external create : unit -> t = "GUI"
  >   [@@bs.new] [@@bs.scope "default"] [@@bs.module "dat.gui"]
  > 
  > let gui = create ()
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external imul : int -> int -> int = "imul" [@@bs.val] [@@bs.scope "Math"]
  > 
  > let res = imul 1 2
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t
  > 
  > external back : t = "back"
  >   [@@bs.module "expo-camera"] [@@bs.scope "Camera", "Constants", "Type"]
  > 
  > let camera_type_back = back
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type param
  > external executeCommands : string -> param array -> unit = ""
  >   [@@bs.scope "commands"] [@@bs.module "vscode"] [@@bs.variadic]
  > 
  > let f a b c = executeCommands "hi" [| a; b; c |]
  > EOF

  $ dune build @melange
  File "input.ml", lines 2-3, characters 0-64:
  2 | external executeCommands : string -> param array -> unit = ""
  3 |   [@@bs.scope "commands"] [@@bs.module "vscode"] [@@bs.variadic]
  Alert fragile: executeCommands : the external name is inferred from val name is unsafe from refactoring when changing value name

  $ cat > input.ml <<\EOF
  > external dirname : string -> string = "dirname" [@@bs.module "path"]
  > let root = dirname "/User/github"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > (* Abstract type for `document` *)
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > let document = document
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > (* Abstract type for `timeoutId` *)
  > type timeoutId
  > external setTimeout : (unit -> unit) -> int -> timeoutId = "setTimeout"
  >   [@@bs.val]
  > external clearTimeout : timeoutId -> unit = "clearTimeout" [@@bs.val]
  > 
  > let id = setTimeout (fun () -> Js.log "hello") 100
  > let () = clearTimeout id
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t
  > external book : unit -> t = "Book" [@@bs.new] [@@bs.module]
  > let myBook = book ()
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t
  > external create_date : unit -> t = "Date" [@@bs.new]
  > let date = create_date ()
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t
  > external create : int -> t = "Int32Array" [@@bs.new]
  > external get : t -> int -> int = "get" [@@bs.get_index]
  > external set : t -> int -> int -> unit = "set" [@@bs.set_index]
  > 
  > let () =
  >   let i32arr = (create 3) in
  >   set i32arr 0 42;
  >   Js.log (get i32arr 0)
  > EOF

  $ dune build @melange
  File "input.ml", line 3, characters 42-54:
  3 | external get : t -> int -> int = "get" [@@bs.get_index]
                                                ^^^^^^^^^^^^
  Error: @get_index this particular external's name needs to be a placeholder empty string
  [1]

  $ cat > input.ml <<\EOF
  > (* Abstract type for the `document` value *)
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > 
  > external set_title : document -> string -> unit = "title" [@@bs.set]
  > external get_title : document -> string = "title" [@@bs.get]
  > 
  > let current = get_title document
  > let () = set_title document "melange"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let homeRoute = route ~_type:"GET" ~path:"/" ~action:(fun _ -> Js.log "Home") ()
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 16-21:
  1 | let homeRoute = route ~_type:"GET" ~path:"/" ~action:(fun _ -> Js.log "Home") ()
                      ^^^^^
  Error: Unbound value route
  [1]

  $ cat > input.ml <<\EOF
  > external route :
  >   _type:string ->
  >   path:string ->
  >   action:(string list -> unit) ->
  >   ?options:< .. > ->
  >   unit ->
  >   _ = ""
  >   [@@bs.obj]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let name_extended obj = obj##name ^ " wayne"
  > 
  > let one = name_extended [%bs.obj { name = "john"; age = 99 }]
  > let two = name_extended [%bs.obj { name = "jane"; address = "1 infinite loop" }]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let john = [%bs.obj { name = "john"; age = 99 }]
  > let t = john##name
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t = {
  >   foo : int; [@bs.as "0"]
  >   bar : string; [@bs.as "1"]
  > }
  > 
  > let value = { foo = 7; bar = "baz" }
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type action = {
  >   type_ : string [@bs.as "type"]
  > }
  > 
  > let action = { type_ = "ADD_USER" }
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type person = {
  >   name : string;
  >   friends : string array;
  >   age : int;
  > }
  > 
  > external john : person = "john" [@@bs.module "MySchool"]
  > let john_name = john.name
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external node_env : string = "NODE_ENV" [@@bs.val] [@@bs.scope "process", "env"]
  > 
  > let development = "development"
  > let () = if node_env <> development then Js.log "Only in Production"
  > 
  > let development_inline = "development" [@@bs.inline]
  > let () = if node_env <> development_inline then Js.log "Only in Production"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let () = match [%bs.external __filename] with
  > | Some f -> Js.log f
  > | None -> Js.log "non-node environment"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let () = match [%bs.external __DEV__] with
  > | Some _ -> Js.log "dev mode"
  > | None -> Js.log "production mode"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let f x y =
  >   [%bs.debugger];
  >   x + y
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > [%%bs.raw "var a = 1"]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let f : unit -> int = [%bs.raw "function() {return 1}"]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let add = [%bs.raw {|
  >   function(a, b) {
  >     console.log("hello from raw JavaScript!");
  >     return a + b;
  >   }
  > |}]
  > 
  > let () = Js.log (add 1 2)
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let r = [%bs.re "/b/g"]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let () = React.useEffect2 (fun () -> None) (foo, bar)
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 9-25:
  1 | let () = React.useEffect2 (fun () -> None) (foo, bar)
               ^^^^^^^^^^^^^^^^
  Error: Unbound module React
  [1]

  $ cat > input.ml <<\EOF
  > let world = {j|世界|j}
  > let helloWorld = {j|你好，$world|j}
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let () = Js.log {js|你好，
  > 世界|js}
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let () = Js.log "你好"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let u = `Foo (* "Foo" *)
  > let v = `Foo(2) (* { NAME: "Foo", VAL: "2" } *)
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type t = A of string | B of int
  > (* A("foo") -> { TAG: 0, _0: "Foo" } *)
  > (* B(2) -> { TAG: 1, _0: 2 } *)
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type tree = Leaf | Node of int * tree * tree
  > (* Leaf -> 0 *)
  > (* Node(7, Leaf, Leaf) -> { _0: 7, _1: 0, _2: 0 } *)
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let sum_sq =
  >   [ 1; 2; 3 ]
  >   |. Belt.List.map String.cat
  >   |. sum
  > EOF

  $ dune build @melange
  File "input.ml", line 4, characters 5-8:
  4 |   |. sum
           ^^^
  Error: Unbound value sum
  [1]

  $ cat > input.ml <<\EOF
  > let sum_sq =
  >   [ 1; 2; 3 ]
  >   |. Belt.List.map square
  >   |. sum
  > EOF

  $ dune build @melange
  File "input.ml", line 4, characters 5-8:
  4 |   |. sum
           ^^^
  Error: Unbound value sum
  [1]

  $ cat > input.ml <<\EOF
  > let sum_sq =
  >   [ 1; 2; 3 ]
  >   |> List.map String.cat
  >   |> sum
  > EOF

  $ dune build @melange
  File "input.ml", line 4, characters 5-8:
  4 |   |> sum
           ^^^
  Error: Unbound value sum
  [1]

  $ cat > input.ml <<\EOF
  > let sum = List.fold_left ( + ) 0
  > 
  > let sum_sq =
  >   [ 1; 2; 3 ]
  >   |> List.map square (* [1; 4; 9] *)
  >   |> sum             (* 1 + 4 + 9 *)
  > EOF

  $ dune build @melange
  File "input.ml", line 5, characters 14-20:
  5 |   |> List.map square (* [1; 4; 9] *)
                    ^^^^^^
  Error: Unbound value square
  [1]

  $ cat > input.ml <<\EOF
  > let ten = 3 |> square |> succ
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 15-21:
  1 | let ten = 3 |> square |> succ
                     ^^^^^^
  Error: Unbound value square
  [1]

  $ cat > input.ml <<\EOF
  > let ten = succ (square 3)
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 16-22:
  1 | let ten = succ (square 3)
                      ^^^^^^
  Error: Unbound value square
  [1]

  $ cat > input.ml <<\EOF
  > let square x = x * x
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > let ( |> ) f g = g f
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type document
  > 
  > external document : document = "document" [@@bs.val]
  > external set_title : document -> string -> unit = "title" [@@bs.set]
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type document
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > type foo = string
  > type bar = int
  > external danger_zone : foo -> bar = "%identity"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external my_c_function : int -> string = "someCFunctionName"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > external clearTimeout : timeoutId -> unit = "clearTimeout" [@@bs.val]
  > 
  > type t = {
  >   age : int; [@bs.as "a"]
  >   name : string; [@bs.as "n"]
  > }
  > EOF

  $ dune build @melange
  File "input.ml", line 1, characters 24-33:
  1 | external clearTimeout : timeoutId -> unit = "clearTimeout" [@@bs.val]
                              ^^^^^^^^^
  Error: Unbound type constructor timeoutId
  [1]

  $ cat > input.ml <<\EOF
  > type name =
  >   | Name of string [@@unboxed]
  > let student_name = Name "alice"
  > EOF

  $ dune build @melange

  $ cat > input.ml <<\EOF
  > [%%bs.raw "var a = 1; var b = 2"]
  > let add = [%bs.raw "a + b"]
  > EOF

  $ dune build @melange

