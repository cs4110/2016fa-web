(* Cornell CS 4110: Lecture 31
 * (Based on Dan Grossman's Graduate Programming Languages; Lecture 21 *)

open Thread
open Event (* for CML *)

let sendNow ch a = sync (send ch a) (*block *)
let recvNow ch = sync (receive ch)

type action = Put of float | Get of float
type account = action channel * float channel
let mkAcct () =
  let inCh  = new_channel() in
  let outCh = new_channel() in
  let bal   = ref 0.0       in (* state *)
  let rec loop () =
    (match recvNow inCh with (* blocks *)
      Put f -> bal := !bal +. f
    | Get f -> bal := !bal -. f); (* allows overdraw *)
    sendNow outCh !bal; loop ()
in ignore(create loop ()); (* launch "server" *)
   (inCh,outCh) (* return channels *)

let mkAcct_cooler () =
  let inCh  = new_channel() in
  let outCh = new_channel() in
  let rec loop bal = (* state is the loop-argument *)
    let newbal =
      match recvNow inCh with (* blocks *)
        Put f -> bal +. f
      | Get f -> bal -. f (* allows overdraw *)
    in sendNow outCh newbal; loop newbal
  in ignore(create loop 0.0);
     (inCh,outCh)

let get (inCh,outCh) f =
  sendNow inCh (Get f); recvNow outCh

let put (inCh,outCh) f =
  sendNow inCh (Put f); recvNow outCh

let squares = new_channel()
let rec loop i =
  sendNow squares (i*i);
  loop (i+1)
let _ = create loop 1

let next_square () = recvNow squares

let one  = next_square()
let four = next_square()
let nine = next_square()

let pr i = print_string ((string_of_int i) ^ "\n")

let _ = pr one; pr four; pr nine

(* Note: this code sends result on out, so it has type
     int channel -> int channel -> int channel -> int,
   unlike the slides where we assumed
     int channel -> int channel -> int,
   but same idea *)
let add in1 in2 out =
  let ans = sync(choose[
   wrap (receive in1)
        (fun i -> sync (receive in2) + i);
   wrap (receive in2)
        (fun i -> sync (receive in1) + i)])
  in
  sync (send out ans)

let myor in1 in2 =
  sync(choose [
   wrap (receive in1)
        (fun b -> b || sync (receive in2));
   wrap (receive in2)
        (fun b -> b || sync (receive in1))
     ] )

let i1 = new_channel()
let i2 = new_channel()
let o = new_channel()
let _ = create (add i1 i2) o
let _ = sync (send i2 7)
let _ = sync (send i1 9)
let _ = pr (sync (receive o))
