# okeno-schema-markers (vendored)

The declarations of the domain language dialect's decorators (`@command`,
`@readModel`, `@rest`, `@event`, `@restResponse`, `@actor`, `@workObject`,
`@icon`, `@from`). Every decorator is a no-op; a tool reads its arguments off
the model. This copy lets the templates compile here, independent of any tool
that imports them. Keep it in step with the dialect when a decorator is added.
