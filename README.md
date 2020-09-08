# little-lua-glob

A little implementation of glob in Lua.

This library is ported from https://github.com/ryanuber/go-glob.
Unlike other implementations which support all kinds of wildcard, this library only supports '\*'.
However, supporting '\*' is enough for most of cases while keeping the implementation simple.

Compared with other implementations, this library has several advantages:
* simple: you can put the single Lua file in your project directly.
* safe: it doesn't use backtrack to match the (possibly evil) user input, see [security](#security) section for the details.

As for the performance, this library is almost as fast as a PCRE regex base implementation. See the ./benchmark.lua for the details.

## Usage

```lua
local glob = require "glob"
local pat = "a.*b.com"
local matcher = glob.compile(pat)
print(matcher:match("a.aliyun.b.com"))
```

## Security

Like regex, if the greedy pattern is (incorrecly) used in the glob implementation, an evil user input may cause terrible performance problem. For example:

```go
package main

import (
	"fmt"
	"strings"
	"time"

	"github.com/gobwas/glob"
)

func main() {
	s := strings.Repeat("12345", 25)
	pat := strings.Repeat("*5", 25)

	start = time.Now()
	var g glob.Glob
	g = glob.MustCompile(pat)
	rb := g.Match(s)
	fmt.Printf("%+v %v\n", time.Now().Sub(start), rb)
}
```

In the `./benchmark.lua`, if I use `.*` instead of `.*?` in the regex base implementation, there will have the same problem.
