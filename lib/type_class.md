# Semigroup

## (<>) :: a -> a -> a

# Monoid

## mempty :: a
## mappend :: a -> a -> a
## mconcat :: [a] -> a

---
---
---

# Functor

## fmap :: Functor f => (a -> b) -> f a -> f b
## (<$>) :: Functor f => (a -> b) -> f a -> f b

# Applicative

## (<*>) :: Applicative f => f (a -> b) -> f a -> f b
## pure :: Applicative f => a -> f a

# Monad

## (>>=) :: Monad m => m a -> (a -> m b) -> m b
## (>>) :: Monad m => m a -> m b -> m b
## return :: Monad m => a -> m a
## fail :: Monad m => String -> m a
