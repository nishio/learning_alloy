sig Person {
    love: Person
}

run {
    some x: Person {
         x.love.love = x
    }
}