# pancreato-manifest
repo manifest-holding repo for the pancreato project

the pancreato project is a systems-focused effort to generate suitable Yocto images including and compatible with the OpenAPS suite for building your own artifical pancreas device.

It currently targets several hardware families: (as of 6/2018)

- Intel Edison (+ Explorer)
- Raspberry Pi Zero W (+ Explorer HAT)
- NXP i.MX6UL
- NXP i.MX7

## using this repo-of-repos

You're going to need [repo](https://gerrit.googlesource.com/git-repo/), the tool that says "sup, dawg, I herd you liek revision control so I put revision control inside your revision control so you can clone while you clone"

You're also going to need to pick a branch to try.  For example, `rocko`, the only legitimate one so far:

```
$ repo init -u https://github.com/thecubic/pancreato-manifest.git -b rocko
$ repo sync
```

You should now have a copy of all the repositories necessary for building systems.

## why is `master` so bare?

`master` is the promised land - the state when all covered things build and work fine.  There's a lot of work to do, most of it in repositories references by this one.
