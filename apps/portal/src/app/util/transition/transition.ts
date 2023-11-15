import { NgZone } from '@angular/core';
import {
  EMPTY,
  fromEvent,
  Observable,
  of,
  OperatorFunction,
  race,
  Subject,
  timer,
} from 'rxjs';
import { endWith, filter, takeUntil } from 'rxjs/operators';
import { getTransitionDurationMs } from './util';

export function runInZone<T>(zone: NgZone): OperatorFunction<T, T> {
  return (source) => {
    return new Observable((observer) => {
      const next = (value: T) => zone.run(() => observer.next(value));
      const error = (e: any) => zone.run(() => observer.error(e));
      const complete = () => zone.run(() => observer.complete());
      return source.subscribe({ next, error, complete });
    });
  };
}

export type TransitionStartFn<T = any> = (
  element: HTMLElement,
  animation: boolean,
  context: T
) => TransitionEndFn | void;
export type TransitionEndFn = () => void;

export interface TransitionOptions<T> {
  animation: boolean;
  runningTransition: 'continue' | 'stop';
  context?: T;
}

export interface TransitionCtx<T> {
  transition$: Subject<any>;
  complete: () => void;
  context: T;
}

// eslint-disable-next-line @typescript-eslint/no-empty-function
export const noopFn: TransitionEndFn = () => {};

const transitionTimerDelayMs = 5;
const runningTransitions = new Map<HTMLElement, TransitionCtx<any>>();

export const runTransition = <T>(
  zone: NgZone,
  element: HTMLElement,
  startFn: TransitionStartFn<T>,
  options: TransitionOptions<T>
): Observable<void> => {
  let context = options.context || <T>{};

  const running = runningTransitions.get(element);
  if (running) {
    switch (options.runningTransition) {
      case 'continue':
        return EMPTY;
      case 'stop':
        zone.run(() => running.transition$.complete());
        context = Object.assign(running.context, context);
        runningTransitions.delete(element);
    }
  }

  const endFn = startFn(element, options.animation, context) || noopFn;

  if (
    !options.animation ||
    window.getComputedStyle(element).transitionProperty === 'none'
  ) {
    zone.run(() => endFn());
    return of(undefined).pipe(runInZone(zone));
  }

  const transition$ = new Subject<void>();
  const finishTransition$ = new Subject<void>();
  const stop$ = transition$.pipe(endWith(true));
  runningTransitions.set(element, {
    transition$,
    complete: () => {
      finishTransition$.next();
      finishTransition$.complete();
    },
    context,
  });

  const transitionDurationMs = getTransitionDurationMs(element);

  zone.runOutsideAngular(() => {
    const transitionEnd$ = fromEvent(element, 'transitionend').pipe(
      takeUntil(stop$),
      filter(({ target }) => target === element)
    );
    const timer$ = timer(transitionDurationMs + transitionTimerDelayMs).pipe(
      takeUntil(stop$)
    );

    race(timer$, transitionEnd$, finishTransition$)
      .pipe(takeUntil(stop$))
      .subscribe(() => {
        runningTransitions.delete(element);
        zone.run(() => {
          endFn();
          transition$.next();
          transition$.complete();
        });
      });
  });

  return transition$.asObservable();
};

export const completeTransition = (element: HTMLElement) => {
  runningTransitions.get(element)?.complete();
};
