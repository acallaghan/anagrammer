# Anagram solver - by [acallaghan](https://github.com/acallaghan/)

[See it live on Heroku here](https://anagram-acallaghan.herokuapp.com/deploy,ruby,thing,get,slime,alerts,with,heroku).

A simple Puma/Rack server running Sinatra that responds to incoming GET requests using Heroku. 

## Structure

I've opted to do as much of the calculations offline, as to make the response time from the server as fast as possible. The pre-calculated anagrams are stored in memory on boot, and simply accessed on each request.

The `WordList` class reads in the text file, parses it and returns back an hash of arrays. The key to each of these arrays is a string sorted by character.

This works on the principle that word anagrams will have equivalent sorted strings. i.e. `'mast'` after parsing gets added into the array for this hash.

```{ "amst" => ["mast", "mats", "tams"]}```

As each new match gets found with the same sorted string, it simply gets added into the array.

This means that during a request, the only real work being done is sorting the input string(s) in the same way, and doing a fetch on that giant hash in memory to get all the anagrams for the word. This produces an extremely good response time for lookups via Heroku.

## Specs

The specs much smaller test wordlist file for when we're only looking at a small subsection of anagrams and the unit tests. It only ever loads in the list located in `./spec/data`, so that the tests are able to run much faster.

The real word list is loaded and tested during the request specs, and there's a performance test to check for the IPS that the algorithm can reply with.

## Heroku warmup

Due to the parsing taking place on boot, the dormant free Heroku dyno will take 5-10 seconds to respond to the first request, as it is rebooting after inactivity. Subsequent requests after this warmup will be sub 5ms responses. 

Paying for this dyno would remove this warmup time, as Heroku wouldn't deactivate it after the period of inactivity.

## Real-world benchmarking

You can see the results of my `ab` benchmark below. Even during high traffic, 50% were completed within 160ms, and only around 2% took longer than 500ms.

```
$ ab -n 1000 -c 10 https://anagram-acallaghan.herokuapp.com/deploy,ruby,thing,get,slime,alerts,with,heroku
This is ApacheBench, Version 2.3 <$Revision: 1826891 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking anagram-acallaghan.herokuapp.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests

...

Concurrency Level:      10
Time taken for tests:   19.211 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      452000 bytes
HTML transferred:       259000 bytes
Requests per second:    52.05 [#/sec] (mean)
Time per request:       192.114 [ms] (mean)
Time per request:       19.211 [ms] (mean, across all concurrent requests)
Transfer rate:          22.98 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:       99  145  86.8    121     769
Processing:    30   44  44.1     36     471
Waiting:       29   43  43.2     36     454
Total:        134  189 108.0    159     980

Percentage of the requests served within a certain time (ms)
  50%    159
  66%    164
  75%    169
  80%    173
  90%    201
  95%    459
  98%    578
  99%    782
 100%    980 (longest request)
 ```
