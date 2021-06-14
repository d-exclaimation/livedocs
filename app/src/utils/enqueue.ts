//
//  enqueue.ts
//  echoppe
//
//  Created by d-exclaimation on 14:18.
//

/**
 * Any function that takes no argument does not return a value
 */
export type ThreadTask = () => void;

/**
 * Returned TaskQueue from a ThreadTask, which is either a Timeout or a Promise
 * ```ts
 * const ref: NodeJS.Timeout = enqueue(() => {});
 * clearTimeout(ref);
 * ```
 */
export type TaskQueue<Fn extends ThreadTask> =
  | number
  | NodeJS.Timeout
  | Promise<void | ReturnType<Fn>>;

/**
 * QueueOptions
 * Macro / Micro task
 */
export type QueueOptions = { task: "macro"; delay: number } | { task: "micro" };

/**
 * Queued a function / callback to the macro / micro task (defaults to "macro")
 *
 * ---
 * e.g.
 * ```ts
 * enqueue(() => console.log("hello"));
 * console.log("hello again");
 * ```
 * 1. hello again
 * 2. hello
 */
export const enqueue = <Fn extends ThreadTask>(
  task: Fn,
  options: QueueOptions = { task: "macro", delay: 0 }
): TaskQueue<Fn> =>
  options.task === "macro"
    ? setTimeout(task, options.delay)
    : Promise.resolve().then(task);
