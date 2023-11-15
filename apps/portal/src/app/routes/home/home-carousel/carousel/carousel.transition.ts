import { noopFn, TransitionStartFn } from '../../../../util/transition/transition';

export enum SlideEventDirection {
  START = 'start',
  END = 'end'
}

export interface CarouselContext {
  direction: SlideEventDirection;
}

const isBeingAnimated = ({ classList }: HTMLElement) => {
  return classList.contains('carousel-item-start') || classList.contains('carousel-item-end');
};

const removeDirectionClasses = (classList: DOMTokenList) => {
  classList.remove('carousel-item-start');
  classList.remove('carousel-item-end');
};

const removeClasses = (classList: DOMTokenList) => {
  removeDirectionClasses(classList);
  classList.remove('carousel-item-prev');
  classList.remove('carousel-item-next');
};

export const carouselTransitionIn: TransitionStartFn<CarouselContext> =
  (element: HTMLElement, animation: boolean, { direction }: CarouselContext) => {
    const { classList } = element;

    if (!animation) {
      removeDirectionClasses(classList);
      removeClasses(classList);
      classList.add('active');
      return noopFn;
    }

    if (isBeingAnimated(element)) {
      // Revert the transition
      removeDirectionClasses(classList);
    } else {
      // For the 'in' transition, a 'pre-class' is applied to the element to ensure its visibility
      classList.add('carousel-item-' + (direction === SlideEventDirection.START ? 'next' : 'prev'));
      element.getBoundingClientRect();
      classList.add('carousel-item-' + direction);
    }

    return () => {
      removeClasses(classList);
      classList.add('active');
    };
  };

export const carouselTransitionOut: TransitionStartFn<CarouselContext> =
  (element: HTMLElement, animation: boolean, { direction }: CarouselContext) => {
    const { classList } = element;

    if (!animation) {
      removeDirectionClasses(classList);
      removeClasses(classList);
      classList.remove('active');
      return noopFn;
    }

    //  direction is left or right, depending on the way the slide goes out.
    if (isBeingAnimated(element)) {
      // Revert the transition
      removeDirectionClasses(classList);
    } else {
      classList.add('carousel-item-' + direction);
    }

    return () => {
      removeClasses(classList);
      classList.remove('active');
    };
  };
