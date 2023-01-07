// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TodoList{
    struct ToDo{
        string text;
        bool completed;
    }

    ToDo[] public todos;

    // create a new todo
    function create(string calldata _text) external{
        todos.push(ToDo(_text, false));
    }

    // update a todo
    function updateText(uint _index, string calldata _text) external{
        todos[_index].text = _text;
        //Todo storage todo = todos[_index]
        //todo.text = _text
    }

    // given an index get a todo's info
    function get(uint _index) external view returns(string memory, bool) {
        ToDo memory todo = todos[_index];
        return (todo.text, todo.completed);

    }

    // toggle the status of a todo
    function toggleCompleted(uint _index) external{
        todos[_index].completed = !todos[_index].completed;
    }

}