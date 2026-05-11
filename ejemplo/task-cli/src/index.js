#!/usr/bin/env node
// task-cli — gestor mínimo de tareas en JSON local.
// Ejemplo del mini-curso de Claude Code.

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const STORE = join(__dirname, "..", "tasks.json");

function load() {
  if (!existsSync(STORE)) return { nextId: 1, tasks: [] };
  return JSON.parse(readFileSync(STORE, "utf8"));
}

function save(state) {
  writeFileSync(STORE, JSON.stringify(state, null, 2));
}

function add(title) {
  if (!title) throw new Error("Falta el título de la tarea.");
  const state = load();
  const task = { id: state.nextId, title, done: false, createdAt: new Date().toISOString() };
  state.tasks.push(task);
  state.nextId += 1;
  save(state);
  console.log(`Agregada: #${task.id} ${task.title}`);
}

function list() {
  const { tasks } = load();
  if (tasks.length === 0) return console.log("Sin tareas.");
  for (const t of tasks) {
    const mark = t.done ? "[x]" : "[ ]";
    console.log(`${mark} #${t.id}  ${t.title}`);
  }
}

function done(id) {
  const state = load();
  const t = state.tasks.find((x) => x.id === Number(id));
  if (!t) throw new Error(`No existe la tarea #${id}`);
  t.done = true;
  save(state);
  console.log(`Marcada: #${t.id} ${t.title}`);
}

function rm(id) {
  const state = load();
  const before = state.tasks.length;
  state.tasks = state.tasks.filter((x) => x.id !== Number(id));
  if (state.tasks.length === before) throw new Error(`No existe la tarea #${id}`);
  save(state);
  console.log(`Borrada: #${id}`);
}

function help() {
  console.log(`task-cli — gestor mínimo de tareas

Uso:
  task-cli add "<titulo>"     Agrega una tarea
  task-cli list                Lista todas
  task-cli done <id>           Marca completada
  task-cli rm <id>             Borra
  task-cli help                Muestra esto`);
}

const [cmd, ...args] = process.argv.slice(2);

try {
  switch (cmd) {
    case "add": add(args.join(" ")); break;
    case "list": list(); break;
    case "done": done(args[0]); break;
    case "rm": rm(args[0]); break;
    case "help": case undefined: help(); break;
    default: throw new Error(`Comando desconocido: ${cmd}. Usa 'task-cli help'.`);
  }
} catch (e) {
  console.error("Error:", e.message);
  process.exit(1);
}
