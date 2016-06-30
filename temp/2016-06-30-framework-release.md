---
layout: post
title: Framework Release
author: Kingsley
authorUrl: https://github.com/jameslkingsley
banner: images/posts/framework-release/banner.jpg
bannerPos: center 92%
---

## What is the framework?
The Mars framework is a set of components that handle all of the tricky parts of a realtime editor for you. Without writing UI's or messing about with controls, you can create new features very quickly. Most of the features currently implemented in the framework are still a work-in-progress but their implementation is unlikely to change.

## What's available?
* [Attributes UI Framework]({{ site.url }}/docs/development/frameworks/attributes/)
* [Context Menus]({{ site.url }}/docs/development/frameworks/context-menus/)
* [Menu Strip Items]({{ site.url }}/docs/development/frameworks/menu-strip/)
* [Toolbar Options]({{ site.url }}/docs/development/frameworks/toolbar/)

## User Interface
As you can probably tell, the Mars interface is practically identical to the Eden interface. This is mainly to reduce the amount of UI work required and also to provide a familiar design to users. There are still some parts to be built such as the entity list and map but the main parts are functional and relatively bug-free.

![Garrison Units, Suppress Position]({{ site.url }}/images/posts/framework-release/interface_01n.jpg)

Using the attributes framework you can create menus with various control types that are perfectly aligned to its grid. You'll never again have to write another UI config or mess about with safezones or grids. Check out the [config](https://github.com/marseditor/mars/blob/master/addons/editor/CfgAttributes.hpp) for the menu shown below.

![Attributes UI]({{ site.url }}/images/posts/framework-release/interface_03.jpg)

Placing objects is also extremely easy. With surface detection you can quickly piece together detailed bases and garrison units by hand without interruption. Any object can be placed on any surface, you just have to hover over it.

![Surface Detection]({{ site.url }}/images/posts/framework-release/interface_04.jpg)

## Roadmap
There's still lots more to do, but I'm happy with the progress so far and as you can see below we're currently sitting on this framework release. Over the next couple of months the 1.0 feature list will hopefully all be ticked off and perhaps with some additional features. Once we're happy with Mars' features we'll start community testing. Community testing is simply testing Mars inside Arma communities that would otherwise use Zeus. This is to get feedback on its usage in the real world, tidy up any bugs there might be and tweak some stuff. If that all goes to plan and we're happy it's not going to spoil a mission for someone, then queue the 1.0 release.

![Roadmap]({{ site.url }}/images/posts/framework-release/roadmap.jpg)

## Contributing
While I *could* write all the features myself, it would take considerbly less time if there were other developers working on it also. If you're familiar with the ACE/CBA development environment, then I urge you to help out. There's a comprehensive list of features that need to be built over on the [GitHub issues](https://github.com/marseditor/mars/issues/1) page. If you've got an idea that's not on the list, submit it as a feature request or speak to me directly - chances are I just forgot to add it, but I'm sure there's plenty more things people can come up with. **Feel free to also join the Mars [Discord](https://discord.gg/0vfzEmmrAOu1T2uk) and [Slack](https://mars-slackin.herokuapp.com/) servers to discuss, develop and troubleshoot.**

Thanks for reading and I hope to show off more features down the line as they're implemented.