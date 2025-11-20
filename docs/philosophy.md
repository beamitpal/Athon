# Philosophy of Athōn

Athōn is built on the belief that software infrastructure should be as durable and reliable as physical infrastructure. We reject the modern trend of "move fast and break things" in favor of "move slowly and build for eternity."

We value **sovereignty** over convenience. It is better to write a feature ourselves than to import a library we do not understand or control. This reduces the attack surface and ensures we can maintain the software even if the rest of the internet disappears.

We value **explicitness** over magic. Hidden control flow, implicit allocations, and global state are the roots of all evil in systems programming. Athōn forces these details into the open, where they can be audited.
