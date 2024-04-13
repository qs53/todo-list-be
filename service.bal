import ballerina/http;

service /covid/status on new http:Listener(9000) {
    resource function get todoList() returns TodoItem[] {
        return todoList.toArray();
    }

    resource function post countries(@http:Payload TodoItem[] todoItems)
                                    returns TodoItem[]|InvalidTodoItemError {

        string[] existingTasks = from TodoItem todoItem in todoItems
            where todoList.hasKey(todoItem.task)
            select todoItem.task;

        if existingTasks.length() > 0 {
            return {
            body: {
                errmsg: string:'join(" ", "Tasks already exist: ", ...existingTasks)
            }
        };
        } else {
            todoItems.forEach(todoItem => todoList.add(todoItem));
            return todoItems;
        }
    }
}

public type TodoItem record {|
    readonly string task;
|};

public final table<TodoItem> key(task) todoList = table [
    {task: "AFG"}, {task: "SL"}, {task: "US"}
];

public type InvalidTodoItemError record {|
    *http:NotFound;
    ErrorMsg body;
|};

public type ErrorMsg record {|
    string errmsg;
|};
