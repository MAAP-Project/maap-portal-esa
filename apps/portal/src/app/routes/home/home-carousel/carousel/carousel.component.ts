import { isPlatformBrowser } from '@angular/common';
import {
  AfterContentChecked,
  AfterContentInit,
  AfterViewInit,
  ChangeDetectorRef,
  Component,
  ContentChildren,
  ElementRef,
  Inject,
  NgZone,
  OnDestroy,
  PLATFORM_ID,
  QueryList,
  ViewEncapsulation,
} from '@angular/core';
import {
  BehaviorSubject,
  combineLatest,
  distinctUntilChanged,
  map,
  NEVER,
  Observable,
  startWith,
  Subject,
  switchMap,
  take,
  takeUntil,
  timer,
  zip,
} from 'rxjs';
import {
  completeTransition,
  runTransition,
  TransitionOptions,
} from '../../../../util/transition/transition';
import { CarouselSlideDirective } from './carousel-slide.directive';
import {
  CarouselContext,
  carouselTransitionIn,
  carouselTransitionOut,
  SlideEventDirection,
} from './carousel.transition';

@Component({
  selector: 'maap-esa-portal-carousel',
  encapsulation: ViewEncapsulation.None,
  host: {
    class: 'carousel slide',
    '[style.display]': '"block"',
    tabIndex: '0',
    '(keydown.arrowLeft)': 'arrowLeft()',
    '(keydown.arrowRight)': 'arrowRight()',
    '(mouseenter)': 'mouseHover = true',
    '(mouseleave)': 'mouseHover = false',
    '(focusin)': 'focused = true',
    '(focusout)': 'focused = false',
    '[attr.aria-activedescendant]': `'slide-' + activeId`,
  },
  templateUrl: './carousel.component.html',
  styleUrls: ['./carousel.component.scss'],
})
export class CarouselComponent
  implements AfterContentChecked, AfterContentInit, AfterViewInit, OnDestroy
{
  @ContentChildren(CarouselSlideDirective)
  slides!: QueryList<CarouselSlideDirective>;

  private _destroy$ = new Subject<void>();

  private _mouseHover$ = new BehaviorSubject(false);
  private _focused$ = new BehaviorSubject(false);
  private _pauseOnHover$ = new BehaviorSubject(false);
  private _pauseOnFocus$ = new BehaviorSubject(false);
  private _pause$ = new BehaviorSubject(true);

  private _interval = 5000;
  private _wrap = true;

  activeId!: string;

  set pauseOnHover(value: boolean) {
    this._pauseOnHover$.next(value);
  }

  get pauseOnHover() {
    return this._pauseOnHover$.value;
  }

  set pauseOnFocus(value: boolean) {
    this._pauseOnFocus$.next(value);
  }

  get pauseOnFocus() {
    return this._pauseOnFocus$.value;
  }

  private _transitionIds: [string, string] | null = null;

  set mouseHover(value: boolean) {
    this._mouseHover$.next(value);
  }

  get mouseHover() {
    return this._mouseHover$.value;
  }

  set focused(value: boolean) {
    this._focused$.next(value);
  }

  get focused() {
    return this._focused$.value;
  }

  constructor(
    @Inject(PLATFORM_ID) private _platformId: object,
    private _ngZone: NgZone,
    private _cd: ChangeDetectorRef,
    private _container: ElementRef
  ) {
    this.pauseOnHover = true;
    this.pauseOnFocus = true;
  }

  arrowLeft() {
    this.focus();
    this.prev();
  }

  arrowRight() {
    this.focus();
    this.next();
  }

  ngAfterContentInit() {
    if (isPlatformBrowser(this._platformId)) {
      this._ngZone.runOutsideAngular(() => {
        const hasNextSlide$ = this.slides.changes.pipe(startWith(null)).pipe(
          map(() => {
            const slideArr = this.slides.toArray();
            return slideArr.length > 1;
          }),
          distinctUntilChanged()
        );
        combineLatest([
          this._pause$,
          this._pauseOnHover$,
          this._mouseHover$,
          this._pauseOnFocus$,
          this._focused$,
          hasNextSlide$,
        ])
          .pipe(
            map(
              ([
                pause,
                pauseOnHover,
                mouseHover,
                pauseOnFocus,
                focused,
                hasNextSlide,
              ]: [boolean, boolean, boolean, boolean, boolean, boolean]) =>
                pause ||
                (pauseOnHover && mouseHover) ||
                (pauseOnFocus && focused) ||
                !hasNextSlide
                  ? 0
                  : this._interval
            ),

            distinctUntilChanged(),
            switchMap((interval) =>
              interval > 0 ? timer(interval, interval) : NEVER
            ),
            takeUntil(this._destroy$)
          )
          .subscribe(() => this._ngZone.run(() => this.next()));
      });
    }

    this.slides.changes.pipe(takeUntil(this._destroy$)).subscribe(() => {
      this._transitionIds?.forEach((id) =>
        completeTransition(this._getSlideElement(id))
      );
      this._transitionIds = null;

      this._cd.markForCheck();

      this._ngZone.onStable.pipe(take(1)).subscribe(() => {
        for (const { id } of this.slides) {
          const element = this._getSlideElement(id);
          if (id === this.activeId) {
            element.classList.add('active');
          } else {
            element.classList.remove('active');
          }
        }
      });
    });
  }

  ngAfterContentChecked() {
    const activeSlide = this._getSlideById(this.activeId);
    this.activeId = activeSlide
      ? activeSlide.id
      : this.slides.length
      ? this.slides.first.id
      : '';
  }

  ngAfterViewInit() {
    if (this.activeId) {
      const element = this._getSlideElement(this.activeId);
      if (element) {
        element.classList.add('active');
      }
    }
  }

  ngOnDestroy() {
    this._destroy$.next();
  }

  select(slideId: string) {
    this._cycleToSelected(
      slideId,
      this._getSlideEventDirection(this.activeId, slideId)
    );
  }

  prev() {
    this._cycleToSelected(
      this._getPrevSlide(this.activeId),
      SlideEventDirection.END
    );
  }

  next() {
    this._cycleToSelected(
      this._getNextSlide(this.activeId),
      SlideEventDirection.START
    );
  }

  pause() {
    this._pause$.next(true);
  }

  cycle() {
    this._pause$.next(false);
  }

  focus() {
    this._container.nativeElement.focus();
  }

  private _cycleToSelected(slideIdx: string, direction: SlideEventDirection) {
    const transitionIds = this._transitionIds;
    if (
      transitionIds &&
      (transitionIds[0] !== slideIdx || transitionIds[1] !== this.activeId)
    ) {
      return;
    }

    const selectedSlide = this._getSlideById(slideIdx);
    if (selectedSlide && selectedSlide.id !== this.activeId) {
      this._transitionIds = [this.activeId, slideIdx];

      const options: TransitionOptions<CarouselContext> = {
        animation: true,
        runningTransition: 'stop',
        context: { direction },
      };

      const transitions: Array<Observable<any>> = [];
      const activeSlide = this._getSlideById(this.activeId);
      if (activeSlide) {
        const activeSlideTransition = runTransition(
          this._ngZone,
          this._getSlideElement(activeSlide.id),
          carouselTransitionOut,
          options
        );
        transitions.push(activeSlideTransition);
      }

      this.activeId = selectedSlide.id;
      const transition = runTransition(
        this._ngZone,
        this._getSlideElement(selectedSlide.id),
        carouselTransitionIn,
        options
      );
      transitions.push(transition);

      zip(...transitions)
        .pipe(take(1))
        .subscribe(() => {
          this._transitionIds = null;
        });
    }

    this._cd.markForCheck();
  }

  private _getSlideEventDirection(
    currentActiveSlideId: string,
    nextActiveSlideId: string
  ): SlideEventDirection {
    const currentActiveSlideIdx = this._getSlideIdxById(currentActiveSlideId);
    const nextActiveSlideIdx = this._getSlideIdxById(nextActiveSlideId);

    return currentActiveSlideIdx > nextActiveSlideIdx
      ? SlideEventDirection.END
      : SlideEventDirection.START;
  }

  private _getSlideById(slideId: string): CarouselSlideDirective | null {
    return this.slides.find((slide) => slide.id === slideId) || null;
  }

  private _getSlideIdxById(slideId: string): number {
    const slide = this._getSlideById(slideId);
    return slide != null ? this.slides.toArray().indexOf(slide) : -1;
  }

  private _getNextSlide(currentSlideId: string): string {
    const slideArr = this.slides.toArray();
    const currentSlideIdx = this._getSlideIdxById(currentSlideId);
    const isLastSlide = currentSlideIdx === slideArr.length - 1;

    return isLastSlide
      ? this._wrap
        ? slideArr[0].id
        : slideArr[slideArr.length - 1].id
      : slideArr[currentSlideIdx + 1].id;
  }

  private _getPrevSlide(currentSlideId: string): string {
    const slideArr = this.slides.toArray();
    const currentSlideIdx = this._getSlideIdxById(currentSlideId);
    const isFirstSlide = currentSlideIdx === 0;

    return isFirstSlide
      ? this._wrap
        ? slideArr[slideArr.length - 1].id
        : slideArr[0].id
      : slideArr[currentSlideIdx - 1].id;
  }

  private _getSlideElement(slideId: string): HTMLElement {
    return this._container.nativeElement.querySelector(`#slide-${slideId}`);
  }
}
