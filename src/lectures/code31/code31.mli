(* Cornell CS 4110: Lecture 31
 * Based on Dan Grossman's Graduate Programming Languages; Lecture 21 *)

(* There's absolutely no indication how the interface is implemented
 * (threads, channels, blocking, server loops, etc.). *)

type account
val mkAcct : unit -> account
val get : account -> float -> float
val put : account -> float -> float

val next_square : unit -> int
