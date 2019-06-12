I'd like to experiment with several ideas related to programming
languages and software development.

## Combinatory Logic & Software Acceleration
There are several recent projects (Awelon, Urbit & Simplicity) that
take an apparently novel approach to programming language
implementation. These projects use a minimalist combinatory logic to
represent all data structures. Certain well-known combinators are
recognized and replaced with equivalent code that is free to use
hardware primitives. In this sense, combinatory logic serves as a
denotational semantics for computation within these systems.

## A "Full-Stack" Application Server
Awelon & Urbit also propose a kind of "full-stack" application
platform spanning many environments.

One interesting thing to note is that Awelon claims this is in part
enabled precisely by the minimalist combinator basis. Awelon's
primitives are device agnostic in the sense that they do nothing but
establish that high order functions exist and can duplicate and erase
information. Device specific primitives are provided by software
acceleration of well-known functions, potentially allowing cross
device code reuse as all devices share a common "alphabet" for
describing computation.

From Simplicity's introductory paper:

> When a suitably rich set of jets is available, we expect the bulk of
> the computation specified by a Simplicity program to be made up of
> these jets, with only a few combinators used to combine the various
> jets. This should bring the computational requirements needed for
> Simplicity programs in line with existing blockchain languages. In
> light of this, one could consider Simplicity to be a family of
> languages, where each language is defined by a set of jets that
> provide computational elements tailored for its particular
> application.

## Crowdsourced Software Development
Awelon, but also [John Shutt's
writings](http://fexpr.blogspot.com/2018/10/lisp-mud-and-wikis.html),
promotes a vision of massively collaborative software development by
loosely connected anonymous developers. Social networking sites like
GitHub are arguably the first steps along this path, but the wiki
concept goes even further by reducing the barrier to entry and
soliciting contributions from random passersby.

Wiki is a good concept but has one major problem: mutable
state. People already get in fights over the content of Wikipedia
pages, because it can only be in one state a time. A more
collaborative model of user generated content is the forum: a forum
thread can accumulate information, and everyone gets a chance to
contribute without a fight breaking out over what the current state of
the thread should be. When a state is decided on, a new thread or
perhaps a sticky can be made, with many posts in succession blessing a
particular narrative.

I'd like to experiment with the idea of a "smart image board":
software like Reddit or Futaba where the analog of "bbcode" can
process data in sophisticated ways, perhaps even performing
server-side effects.

## Program Synthesis
I would also like to experiment with various program synthesis
techniques, and in particular neural nets and probabilistic
programming. I believe synthesis will enable developers to write
nontrivial programs in input-constrained situations, such as on a
smartphone or with a voice controlled assistant.

[code2vec](https://code2vec.org/) transforms abstract syntax trees in
to vectors which capture semantic information.

[Smartsynth](http://vuminhle.com/pdf/mobisys13.pdf) uses natural
language processing techniques to narrow the search space of
smartphone automation scripts.

## Bibliography
- [Awelon](https://github.com/dmbarbour/wikilon/blob/master/docs/AwelonLang.md)
- [Urbit](https://media.urbit.org/whitepaper.pdf)
- [Simplicity](https://blockstream.com/simplicity.pdf)
- [Lisp, mud and wikis](http://fexpr.blogspot.com/2018/10/lisp-mud-and-wikis.html)
- [code2vec](https://code2vec.org/)
- [Synthesizing Smartphone Automation Scripts from Natural Language](http://vuminhle.com/pdf/mobisys13.pdf)
