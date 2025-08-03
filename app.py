import os
import csv
import pandas as pd
import groq
from datetime import datetime
from rich.console import Console
from rich.table import Table

CSV_FILE = "tasks.csv"
console = Console()

# Load API Key securely from environment variable
GROQ_API_KEY = os.getenv("GROQ_API_KEY")

def initialize_csv():
    # Creates the CSV file if it does not exist
    if not os.path.exists(CSV_FILE):
        with open(CSV_FILE, mode="w", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(["Task ID", "Task Name", "Description", "Priority", "Due Date", "Status"])

def generate_task_id():
    # Generates a unique Task ID based on the CSV data
    if not os.path.exists(CSV_FILE) or os.stat(CSV_FILE).st_size == 0:
        return 1
    df = pd.read_csv(CSV_FILE)
    return df["Task ID"].max() + 1 if not df.empty else 1

def add_task():
    # Adds a new task to the task list
    task_id = generate_task_id()
    name = input("Enter Task Name: ").strip()
    description = input("Enter Task Description: ").strip()
    priority = input("Enter Priority (High/Medium/Low): ").strip().capitalize()
    due_date = input("Enter Due Date (YYYY-MM-DD): ").strip()

    try:
        due_date_obj = datetime.strptime(due_date, "%Y-%m-%d").date()
        if due_date_obj < datetime.today().date():
            console.print("[bold red]Error: Due date cannot be in the past![/bold red]")
            return
    except ValueError:
        console.print("[bold red]Error: Invalid date format! Use YYYY-MM-DD.[/bold red]")
        return

    # with open(CSV_FILE, mode="a", newline="") as file:
    #     writer = csv.writer(file)
    #     writer.writerow([task_id, name, description, priority, due_date, "To-Do"])

    console.print("[bold green]Task added successfully![/bold green] ✅")

def view_tasks():
    # Displays task(s) according to user's preference in tabular format
    try:
        df = pd.read_csv("tasks.csv")

        if df.empty:
            console.print("[bold red]No tasks available.[/bold red]")
            return

        # Ask user for sorting preference
        console.print("[bold yellow]Sort by:[/bold yellow] Task ID, Task Name, Priority, Due Date, or Status")
        sort_field = input("Enter sort field (or press Enter to skip): ").strip().title()

        if sort_field in df.columns:
            df = df.sort_values(by=sort_field, ascending=True)

        table = Table(title="Task List", show_header=True, header_style="bold white on blue")
        table.show_lines = True  # Enables horizontal dividers between rows

        # Adding columns with justified text
        table.add_column("Task ID", justify="center")
        table.add_column("Task Name", justify="left")
        table.add_column("Description", justify="left")
        table.add_column("Priority", justify="center")
        table.add_column("Due Date", justify="center")
        table.add_column("Status", justify="center")

        # Adding rows with colors for better visualization
        for _, row in df.iterrows():
            task_id = f"[cyan]{row['Task ID']}[/cyan]"
            task_name = f"[bold white]{row['Task Name']}[/bold white]"
            description = f"[magenta]{row['Description']}[/magenta]"
            priority = f"[yellow]{row['Priority']}[/yellow]"
            due_date = f"[green]{row['Due Date']}[/green]"
            status = f"[red]{row['Status']}[/red]" if row["Status"].strip().lower() == "pending" else f"[bold green]{row['Status']}[/bold green]"

            table.add_row(task_id, task_name, description, priority, due_date, status)

        console.print(table)

    except FileNotFoundError:
        console.print("[bold red]Task file not found. Creating an empty task file...[/bold red]")
        df = pd.DataFrame(columns=["Task ID", "Task Name", "Description", "Priority", "Due Date", "Status"])
        df.to_csv("tasks.csv", index=False)
    except Exception as e:
        console.print(f"[bold red]An error occurred: {e}[/bold red]")

def edit_task():
    # Edits an existing task
    task_id = input("Enter Task ID to edit: ").strip()
    df = pd.read_csv(CSV_FILE)

    if task_id not in df["Task ID"].astype(str).values:
        console.print("[bold red]Error: Task ID not found![/bold red]")
        return

    new_name = input("Enter New Task Name: ").strip()
    new_desc = input("Enter New Description: ").strip()
    new_priority = input("Enter New Priority (High/Medium/Low): ").strip().capitalize()
    new_due_date = input("Enter New Due Date (YYYY-MM-DD): ").strip()

    df.loc[df["Task ID"] == int(task_id), ["Task Name", "Description", "Priority", "Due Date"]] = [
        new_name, new_desc, new_priority, new_due_date
    ]
    df.to_csv(CSV_FILE, index=False)
    console.print("[bold green]Task updated successfully![/bold green] ✅")

def delete_task():
    # Deletes a task from the list
    task_id = input("Enter Task ID to delete: ").strip()
    df = pd.read_csv(CSV_FILE)

    if task_id not in df["Task ID"].astype(str).values:
        console.print("[bold red]Error: Task ID not found![/bold red]")
        return

    df = df[df["Task ID"] != int(task_id)]
    df.to_csv(CSV_FILE, index=False)
    console.print("[bold green]Task deleted successfully![/bold green] ✅")

def update_status():
    # Updates the status of a task
    task_id = input("Enter Task ID to update status: ").strip()
    df = pd.read_csv(CSV_FILE)

    if task_id not in df["Task ID"].astype(str).values:
        console.print("[bold red]Error: Task ID not found![/bold red]")
        return

    new_status = input("Enter New Status (To-Do/In Progress/Completed): ").strip()
    df.loc[df["Task ID"] == int(task_id), "Status"] = new_status
    df.to_csv(CSV_FILE, index=False)
    console.print("[bold green]Task status updated successfully![/bold green] ✅")

def show_insights():
    # Displays analytical insights about tasks
    df = pd.read_csv(CSV_FILE)
    completed_tasks = df[df["Status"] == "Completed"].shape[0]
    pending_tasks = df[df["Status"] != "Completed"].shape[0]
    total_tasks = df.shape[0]

    console.print(f"[bold cyan]📊 Task Insights:[/bold cyan]")
    console.print(f"✅ Completed Tasks: {completed_tasks}")
    console.print(f"⏳ Pending Tasks: {pending_tasks}")
    console.print(f"📌 Total Tasks: {total_tasks}")

def ai_recommendations():
    # Generates AI-powered task recommendations
    if not GROQ_API_KEY:
        console.print("[bold red]Error: Missing GROQ API key![/bold red]")
        return

    df = pd.read_csv(CSV_FILE)
    pending_tasks = df[df["Status"].isin(["To-Do", "In Progress"])]

    if pending_tasks.empty:
        console.print("[bold green]No pending tasks! All set.[/bold green] ✅")
        return

    prompt_text = "Suggest a task order and productivity tips for:\n\n"
    for _, task in pending_tasks.iterrows():
        prompt_text += f"- {task['Task Name']} (Priority: {task['Priority']}, Due: {task['Due Date']})\n"

    client = groq.Client(api_key=GROQ_API_KEY)
    response = client.chat.completions.create(
        model="llama3-8b-8192",
        messages=[{"role": "system", "content": "You are a productivity expert."},
                  {"role": "user", "content": prompt_text}],
        max_tokens=200
    )
    
    console.print(f"[bold green]{response.choices[0].message.content.strip()}[/bold green]\n")

def main():
    initialize_csv()
    while True:
        print("\n1. Add Task\n2. View Tasks\n3. Edit Task\n4. Delete Task\n5. Update Status\n6. Show Insights\n7. AI Recommendations\n8. Exit")
        choice = input("Enter choice: ").strip()
        if choice == "1":
            add_task()
        elif choice == "2":
            view_tasks()
        elif choice == "3":
            edit_task()
        elif choice == "4":
            delete_task()
        elif choice == "5":
            update_status()
        elif choice == "6":
            show_insights()
        elif choice == "7":
            ai_recommendations()
        elif choice == "8":
            break

if __name__ == "__main__":
    main()
