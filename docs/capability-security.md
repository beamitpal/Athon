# Capability-Based Security

Traditional security models (ACLs, user permissions) are coarse-grained and often fail because programs run with the full authority of the user.

Athōn uses **Object-Capability (OCap)** security. A function can only access a resource if it holds a handle (token) to that resource. These tokens are unforgeable and passed explicitly.

This means a supply-chain attack in a string parsing library cannot exfiltrate data over the network, because the string parser function was never passed the `NetworkCap` capability. It physically cannot perform the action.
