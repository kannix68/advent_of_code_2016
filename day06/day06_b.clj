#!/usr/bin/env clojure

; Advent of code 2016, AoC day 6 puzzle 2.
; This solution (clojure 1.8) by kannix68, @ 2016-12-06.

(require '[clojure.string :as str]) ; clj str ops

(defn assert-msg [condit msg]
  "check condition, fail with message on false, print message otherwise"
  (if (not condit)
    (assert condit (str "assert-ERROR:" msg))
    (println "assert-OK:" msg))
)

;** problem solution
(defn explode-str [str]
  "explode a (multiline) string into list-of-lists,
   by splitting first on newlines, then on each character."
  (map #(seq (str/split % #"")) (str/split str #"\r?\n"))
)
(defn transpose-lol [lol]
  "transpose rows <=> columns of a list-of-lists"
  (apply map list lol)
)
(defn get-max-freq-colelems [loltr]
  "get a list of the keys having max frequency for each sequenc in list-of-sequences."
  (map #(key (apply min-key val (frequencies %))) loltr) ; use/map closure #() on each list-elem
)

;** test data (as a var(iable))
(def teststr "eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar")

;** MAIN

; solve/assert test-data
(let [
  lol (explode-str teststr)
  loltr (transpose-lol lol)
  linelen (count (first lol))
  collen (count (first loltr))
  res (get-max-freq-colelems loltr) ; result as list
  result (str/join res) ; result as string
  expected "advent"
  ]
  ;(println "test-string\n" teststr)
  ;(println "transposed list-of-lists") (println loltr)
  (println "line-length=" linelen ", coln-length=" collen)
  (assert-msg (= result expected) (str "test-result " result " should be " expected))
)

; solve my specific data input
(let [
  datastr (slurp "day06_data.txt")
  lol (explode-str datastr)
  loltr (transpose-lol lol)
  linelen (count (first lol))
  collen (count (first loltr))
  res (get-max-freq-colelems loltr) ; result as list
  result (str/join res) ; result as string
  ]
  (println (str "input   #" collen)  (take 2 lol)   "..." (take-last 1 lol))
  (println (str "transpd #" linelen) (take 2 loltr) "..." (take-last 1 loltr))
  (println "data line-len=" linelen ", col-len=" collen)
  (println "result :=> " result)
)
